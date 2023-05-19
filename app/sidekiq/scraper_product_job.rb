# Step 5 Fin
# Take each product and set it up, leave it ready to save the information in the database
class ScraperProductJob
  include Sidekiq::Job
  include MiraxHelper
  include UtilitiesHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, type, category_name, store_id)
    @doc = parsing_html(url)

    # Get the host name
    @uri = URI(url)

    # Set $type_values (MiraxHelper)
    type_values = type_variables(category_name)

    # Set brands with more than one word in the name (MiraxHelper)
    large_brands = large_brands_names

    @final_brand = ''

    # Hash to save data into Product Model
    @product = { 'name' => ' ', 'type' => ' ', 'image' => ' ', 'creation_date' => ' ', 'category_id' => ' ' }
    # Hash to save json description data Product Model
    @description = { 'description' => '', 'scale' => '' }

    #  Hash to save data into Price Model
    @price = { 'product_id' => ' ', 'store_id' => ' ', 'amount' => ' ', 'offer_amount' => ' ', 'current_amount' => ' ' }

    fill_data(type_values, large_brands, type, store_id, category_name)

    save_data
  rescue StandardError => e
    Rails.logger.error "Error en scraper_product_job Step 5 : #{e.message}\n#{e.backtrace.join("\n")}"
  end

  def fill_data(type_values, large_brands, type, store_id, category_name)
    # Get the category and the id
    final_category = Category.getCategoryByName(category_name)

    # Validate the category exists
    raise StandardError, "No se encontró ninguna categoría con nombre #{category_name}" unless final_category.present?

    fill_product_data(final_category, type, type_values, large_brands, category_name)
    fill_description_data(category_name)
    fill_price_data(store_id)
  end

  def fill_product_data(final_category, type, type_values, large_brands, category_name)
    image = ''

    @product['name'] = html_product_name

    # Normalize Brand Name
    brand_name = normalize_brand_name(large_brands)

    @product['name'] = clean_scale(@product) if category_name == 'Maquetas'
    @product['name'] = clean_brand(@product, brand_name, 'name') if @final_brand.name != 'OTROS'

    # category is not identified
    type = category_not_identified(type, type_values)

    @product['type'] = type
    @product['image'] = "#{@uri.host}/#{html_img_url(image)}"
    @product['creation_date'] = creation_date
    @product['category_id'] = final_category.id
  end

  def fill_description_data(category_name)
    html_description
    alternative_scale = html_alternative_scale(category_name)

    # Gets the scale with the 2 formats ( : and / ) and leaves all with ":"
    @description['scale'] = get_scale(@product, 'name') if category_name == 'Maquetas'
    @description['scale'] = /(\w+:\d+)/.match(alternative_scale.last)
    @description['scale'] = get_scale(@description, 'description') if @description['scale'].blank?
  end

  def fill_price_data((store_id))
    @price['store_id'] = store_id
    @price['amount'] = html_price
    @price['current_amount'] = true
  end

  def html_product_name
    @doc.search('.row h1 b').map do |element|
      element.inner_text.strip
    end.first
  end

  def html_price
    @doc.search('.price').map do |element|
      element.inner_text.strip
    end.first
  end

  def html_description
    # Get Description for the json
    @doc.search('#descr').map do |element|
      @description['description'] = element.inner_text.strip
    end
  end

  def html_alternative_scale(category_name)
    # In case the name does not bring the scale
    return unless category_name == 'Maquetas'

    @doc.search('.breadcrumb a').map(&:inner_text).map(&:strip)
  end

  def html_img_url(image)
    @doc.css('img').map do |element|
      image = element.attr('src')
      break if image.include?('productos')
    end
    image
  end

  def category_not_identified(type, type_values)
    # In the event that the category is not identified, it will be set to "others"
    if type.blank?
      type = 'otros'
    else
      type = type.downcase

      type_key = type_values.detect { |key, value| value.any? { |str| type.include?(str) } }&.first
      type = type_key if type_key
    end
    type
  end

  def creation_date
    # Get the creation date
    time = Time.new
    values = time.to_a
    Time.utc(*values)
  end

  def normalize_brand_name(large_brands)
    # Get the brand name
    brand_name = @product['name'].split.first

    # In case the brand name is compose for 2 o more words
    large_brands.each do |key, value|
      brand_name = key if brand_name == value[0]
    end

    # Get the Brand and the id
    @final_brand = Brand.getBrandByName(brand_name)

    # In case that final_brand is a special case
    special_brand = brands_specials_cases(brand_name)

    brand_name = normalize_special_brand(special_brand, brand_name)
  end

  def normalize_special_brand(special_brand, brand_name)
    # Get the mark and complete the name with special character
    special_brand&.each do |element|
      next unless @product['name'].split(/\s+/)&.[](1)&.include?(element)

      brand_name = "#{brand_name} #{element}"
      break
    end
    brand_name
  end

  def save_data
    # Save a new Product
    final_product = Product.addProduct(@product, @description)

    # Save a new Price
    Price.addPrice(final_product.id, @price)

    # Save a new data into the middle table brands_products
    final_product.brands << @final_brand
  end
end
# Step 5 Fin

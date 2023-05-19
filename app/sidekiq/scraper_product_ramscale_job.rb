# Step 4 Fin
# Take each product and set it up, leave it ready to save the information in the database

class ScraperProductRamscaleJob
  include Sidekiq::Job
  include UtilitiesHelper
  include RamscaleHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, category_id, category_name, type, store_id, brand)
    @doc = parsing_html(url)
    brands_names = normalize_brands_names
    type_values = type_variables(category_name)

    # Hash to save data into Product Model
    @product = { 'name' => ' ', 'type' => ' ', 'image' => ' ', 'creation_date' => ' ', 'category_id' => ' ' }
    # Hash to save json description data Product Model
    @description = { 'description' => '', 'scale' => '' }
    #  Hash to save data into Price Model
    @price = { 'product_id' => ' ', 'store_id' => ' ', 'amount' => ' ', 'offer_amount' => ' ', 'current_amount' => ' ' }

    assign_product(type_values, type, category_id)
    assign_description(category_name)
    assign_price(store_id)
    brand = assing_brand(brand, brands_names)

    @product['name'] = clean_scale(@product) if category_name == 'Maquetas'

    print("\n Name : #{@product['name']}")
    print("\n Type : #{@product['type']}")
    print("\n Image : #{@product['image']}")
    print("\n Creation Date : #{@product['creation_date']}")
    print("\n Category id : #{@product['category_id']}")
    print("\n Scale : #{@description['scale']}")
    print("\n Store : #{@price['store_id']}")
    print("\n Price : #{@price['amount']}")
    print("\n Current Amount : #{@price['current_amount']}")
    print("\n Category : #{category_name}")
    print("\n Brand : #{brand.inspect} \n")

    # Save a new Product
    # final_product = Product.addProduct(@product, @description)

    # Save a new Price
    # Price.addPrice(final_product.id, @price)

    # Save a new data into the middle table brands_products
    # final_product.brands << brand
  rescue StandardError => e
    Rails.logger.error "Error en scraper_product_ramscale_job Step 4 : #{e.message}\n#{e.backtrace.join("\n")}"
  end

  def assign_product(type_values, type, category_id)
    product_name
    product_image
    product_time
    @product['type'] = get_type(type, type_values)
    @product['category_id'] = category_id
  end

  def product_name
    # Get products name
    @doc.search('.card__section h1').map do |element|
      @product['name'] = element.text
    end
  end

  def product_image
    image = ''
    # Get Img UrL
    @doc.css('img').map do |element|
      image = element.attr('src')
      break if image&.include?('products')
    end
    @product['image'] = image
  end

  def product_time
    # Get the creation date
    time = Time.new
    values = time.to_a
    @product['creation_date'] = Time.utc(*values)
  end

  def assign_description(category_name)
    text_description = ''

    # Get Description for the json
    @doc.search('.rte.text--pull span').map do |element|
      text_description = "#{text_description}#{element.inner_text.strip}"
    end

    @description['description'] = text_description

    # Gets the scale with the 2 formats ( : and / ) and leaves all with ":"
    @description['scale'] = get_scale(@product, 'name') if category_name == 'Maquetas'
    @description['scale'] = get_scale(@description, 'description') if @description['scale'].blank?
  end

  def assign_price(store_id)
    @price['store_id'] = store_id

    @doc.search('.price').map do |element|
      @price['amount'] = element.inner_text.strip
    end

    @price['current_amount'] = true
  end

  def assing_brand(brand, brands_names)
    brands_names.each do |key, value|
      brand = key if brand.upcase.include? value[0]
    end

    # Get the Brand and the id
    brand = Brand.getBrandByName(brand)
  end

  def get_type(type, type_values)
    if type.blank?
      'otros'
    else
      type = type.downcase
      type_values.detect { |_key, values| values.any? { |value| type.include?(value) } }&.first || type # TODO: 'otros'
    end
  end
end
# Step 5 Fin

# https://www.mirax.cl/detalles.php?codigo=235308
# https://www.ramscale.cl/products/pintura-matt-earth-fs-34088

# El Brand viene siendo la sub_categoria, onda Ammo, Mission model, pero en el caso de las maquetas es tipo
# y el tipo es la marca, se intercambian

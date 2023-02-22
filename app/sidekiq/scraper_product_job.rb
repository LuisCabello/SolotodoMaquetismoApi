# Step 5 Fin
# Take each product and set it up, leave it ready to save the information in the database

class ScraperProductJob
  include Sidekiq::Job
  include MiraxHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'csv'

  def perform(url, type, category_name, _store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)
    image = ''
    category_exists = false

    # Set $type_values
    type_values = global_variables(category_name)

    # Hash to save data into Product Model
    product = { 'name' => ' ', 'type' => ' ', 'image' => ' ', 'creation_date' => ' ', 'category_id' => ' ' }
    # Hash to save json description data Product Model
    description = { 'description' => '', 'scale' => '' }

    #  Hash to save data into Price Model
    price = { 'product_id' => ' ', 'store_id' => ' ', 'amount' => ' ', 'offer_amount' => ' ', 'current_amount' => ' ' }

    # Get the category and the id
    @category_filter = Category.new
    final_category = @category_filter.getCategoryByName(category_name)

    # Revisar bien lo de manejo de errores
    if final_category.present?
      product['category_id'] = final_category.id
    else
      # Handle the error
      raise StandardError, "No se encontró ninguna categoría con nombre #{category_name}"
      # Set the category to "Otros"
      # categories_by_name = @category_filter.getCategoryByName("Otros")
      # product['category_id'] = categories_by_name.id
    end

    doc.search('.row h1').map do |element|
      product['name'] = element.inner_text.strip
    end

    doc.search('.price').map do |element|
      price['amount'] = element.inner_text.strip
    end

    # En caso de que no se identifique la categoria se deja como "otros"
    if type.blank?
      type = 'Otros'
    else
      type.downcase!

      type_values.each do |key, value|
        value.each do |stringValue|
          next unless type.include?(stringValue)

          type = key
          category_exists = true
          break
        end
      end
    end

    product['type'] = type

    # Get Description for the json
    doc.search('#descr').map do |element|
      description['description'] = element.inner_text.strip
    end

    # Get Img UrL
    doc.css('img').map do |element|
      image = element.attr('src')
      break if image.include?('productos')
    end

    # Get the host name
    uri = URI(url)
    product['image'] = "#{uri.host}/#{image}"

    # Get the creation date
    time = Time.new
    values = time.to_a
    product['creation_date'] = Time.utc(*values)

    name_product = product['name']

    # Get the brand name
    brand_name = name_product.partition(' ').first

    # Get the Brand and the id
    @brand = Brand.new
    final_brand =  @brand.getBrandByName(brand_name)

    # String to array
    name_product = name_product.split

    # !!!! TAL VEZ SI NO ENCUENTRA ESCALA QUE QUEDE COMO OTROS? PERO QUE TENGA QUE SER MAQUETA
    # Get the scale from the name product
    name_product.each do |x|
      if x.include?(':')
        description['scale'] = x
        break
      end
    end

    # Clean the name of the product
    name_product.delete_if { |x| x.include?(':') }
    name_product.delete_if { |x| x.include?(brand_name) }

    # Final name of the product
    name_product = name_product.join(' ')
    product['name'] = name_product

    # if there is no data it is not shown
    # description = description.to_json

    # Save a new Product
    # final_product = Product.new
    # final_product = final_product.addProduct(product['name'], description, type, product['image'], product['creation_date'],
    #                                          product['category_id'])
    # final_product.categories << final_category

    # # Save a new Price
    # final_price = Price.new
    # final_price = final_price.addPrice(final_product.id, store_id, price['amount'].delete('^0-9').to_i,
    #                                    price['offer_amount'], price['current_amount'])

    # # print(final_price.errors.full_messages)

    # # Save a new data into the middle table brands_products
    # final_product.brands << final_brand
  end
end
# Step 5 Fin

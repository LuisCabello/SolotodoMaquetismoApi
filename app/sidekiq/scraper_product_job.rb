# Paso 5
# Toma cada producto y lo setea, lo deja listo para guardar la informacion en la base de datos

class ScraperProductJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'csv'

  # HAY QUE MENEJAR LA CATEGORIA AQUI!
  def perform(url)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)
    image = ''

    # Hash to save data
    product = { 'name' => ' ', 'price' => ' ', 'offer_price' => ' ', 'type' => ' ', 'image' => ' ',
                'creation_date' => ' ', 'category' => ' ', 'brand' => ' ' }
    # Hash to save json description data
    description = { 'description' => '', 'scale' => '' }

    doc.search('.row h1').map do |element|
      product['name'] = element.inner_text.strip
    end

    doc.search('.price').map do |element|
      product['price'] = element.inner_text.strip
    end

    #------------------- Description

    # Dejar para despues
    # # Description for the json 
    # doc.search('span').map do |element|
    #   description['description'] = element.inner_text.strip
    # end

    # # Hay que pasarlas a un jsonb
    # # categoria, tipo, escala
    # doc.search('.breadcrumb').map do |element|
    #   element.inner_text.strip
    # end

    #------------------- 

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

    nameProduct = product['name']

    # Get the brand
    brand = nameProduct.partition(' ').first

    # String to array
    nameProduct = nameProduct.split

    # Get the scale from the name product
    nameProduct.each do |x|
      if x.include?(':')
        description['scale'] = x
        break
      end
    end

    # Clean the name of the product
    nameProduct.delete_if { |x| x.include?(':') }
    nameProduct.delete_if { |x| x.include?(brand) }

    # Final name of the product
    nameProduct = nameProduct.join(' ')
    product['name'] = nameProduct

    # if there is no data it is not shown
    # description = description.to_json

    # Hay datos que no van en el modelo Product, si no que van en otro modelo
    # Para las relaciones con las otras clases tenemos que ver como conseguir sus ids

    # Create a new product and add the data to it, then we save it in the database
    # final_product = Product.new
    # final_product.name = product["name"]
    # # final_product.price = product["price"]
    # # final_product.offer_price = product["offer_price"]
    # final_product.type = product["type"]
    # final_product.image = product["image"]
    # final_product.creation_date = product["creation_date"]
    # # final_product.category = product["category"]
    # # final_product.brand = product["brand"]
    # final_product.save
  end
end

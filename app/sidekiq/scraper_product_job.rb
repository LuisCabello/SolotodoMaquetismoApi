# Step 5 Fin
# Take each product and set it up, leave it ready to save the information in the database

class ScraperProductJob
  include Sidekiq::Job
  include MiraxHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'csv'

  def perform(url, type, category_name, store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)
    image = ''
    category_exists = false
    alternative_scale = ''
    name_product = ''

    # Set $type_values (MiraxHelper)
    type_values = type_variables(category_name)

    # Set brands with more than one word in the name (MiraxHelper)
    large_brands = large_brands_names

    # Hash to save data into Product Model
    product = { 'name' => ' ', 'type' => ' ', 'image' => ' ', 'creation_date' => ' ', 'category_id' => ' ' }
    # Hash to save json description data Product Model
    description = { 'description' => '', 'scale' => '' }

    #  Hash to save data into Price Model
    price = { 'product_id' => ' ', 'store_id' => ' ', 'amount' => ' ', 'offer_amount' => ' ', 'current_amount' => ' ' }

    # Get the category and the id
    @category_filter = Category.new
    final_category = @category_filter.getCategoryByName(category_name)

    # Validate the category exists
    raise StandardError, "No se encontró ninguna categoría con nombre #{category_name}" unless final_category.present?

    product['category_id'] = final_category.id
    price['store_id'] = store_id

    doc.search('.row h1 b').map do |element|
      name_product = element.inner_text.strip
    end

    doc.search('.price').map do |element|
      price['amount'] = element.inner_text.strip
    end

    # Get Description for the json
    doc.search('#descr').map do |element|
      description['description'] = element.inner_text.strip
    end

    # In case the name does not bring the scale
    if category_name == 'Maquetas'
      doc.search('.breadcrumb a').map do |element|
        alternative_scale = element.inner_text.strip
      end
    end

    # Get Img UrL
    doc.css('img').map do |element|
      image = element.attr('src')
      break if image.include?('productos')
    end

    # In the event that the category is not identified, it will be set to "others"
    if type.blank?
      type = 'otros'
    else
      type.downcase

      # Tal vez sacar el segundo recorrido
      type_values.each do |key, value|
        value.each do |string_value|
          next unless type.include?(string_value)

          type = key
          category_exists = true
          break
        end
      end
    end

    product['type'] = type

    # Get the host name
    uri = URI(url)
    product['image'] = "#{uri.host}/#{image}"

    # Get the creation date
    time = Time.new
    values = time.to_a
    product['creation_date'] = Time.utc(*values)

    # Get the brand name
    brand_name = name_product.partition(' ').first

    # In case the brand name is compose for 2 o more words
    large_brands.each do |key, value|
      brand_name = key if brand_name == value[0]
    end

    # Get the Brand and the id
    @brand = Brand.new
    final_brand = @brand.getBrandByName(brand_name)

    # In case that final_brand is a special case
    special_brand = brands_specials_cases(brand_name)

    if special_brand
      special_brand.each do |element|
        next unless name_product.split(/\s+/)[1].include? element

        brand_name = brand_name + ' ' + element
        break
      end
    end

    # Gets the scale with the 2 formats ( : and / ) and leaves all with ":"
    scale = /(\w+:\d+)/.match(name_product)

    if category_name == 'Maquetas'
      if scale
        description['scale'] = scale.to_s
      elsif category_name == 'Maquetas'
        description['scale'] = /(\w+:\d+)/.match(alternative_scale).to_s
        if description['scale'].blank?
          description['scale'] = %r{(?<word>\w*/\d+)\s}.match(name_product).to_s.gsub('/', ':')
        end
      end
    end

    # Clean the name, delete the brand and the scale( : and / )
    if category_name == 'Maquetas'
      name_product = name_product.gsub(/(\w+:\d+)/, '').gsub(%r{(?<word>\w*/\d+)\s},
                                                             '').strip
    end
    name_product = name_product.gsub(brand_name, '').gsub(/\s{2,}/, ' ').strip if final_brand.name != 'OTROS'

    # Final name of the product
    product['name'] = name_product

    # print("\nEl nombre es : #{product['name']} \n")
    # print("El tipo es : #{product['type']} \n")
    # print("La escala es : #{description['scale']} \n")
    # print("la marca es : #{final_brand.name} \n")
    # print("El precio es :  #{price['amount']} \n")

    # Save a new Product
    final_product = Product.new
    final_product = final_product.addProduct(product, description)

    # Save a new Price
    final_price = Price.new
    final_price.addPrice(final_product.id, price)

    # Save a new data into the middle table brands_products
    final_product.brands << final_brand
  rescue StandardError => e
    Rails.logger.error "Error en scraper_product_job Step 5 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
# Step 5 Fin

# Falto asegurar que los typos estuvieran todos en minuscula o mayuscula --
# Algunos productos aun siguen con sus marcas en los nombres ya que son doble palabra --
# Revisar las pinturas k4 al parecer tienen la palabra FS al lado
# AMMO MIG JIMENEZ --
# FANTASY FLIGHT GAMES --
# lA MARCA WIZKIDS TAMBIEN APARECE COMO "WIZKIDS MARVEL"
# atomic es "ATOMIC MASS GAMES" --
# MODEL ES "MODEL GRAPHIX" --
# Tambien BILLING BOATS --
# ARMY ES "ARMY PAINTER" --
# Revisar "ACALL TO ARMS" --

# Atento a "LIBRO ENGLISH HEAVY TANKS EN RUSO" y "LIBRO TANK OF KAISER WWI EN RUSO" porque son libros y al parecer tienen escrita una escala en el nombre y se la sacamos
# REVISAR LA MARCA "ATLANTIS MODELS"
# "COLLECTIONS JAPAN 1S004 MACROSS VF-1 VALKYRIE FIGHTER MODE DIECAST GIMMICK MODEL -004"	"Macross"	"www.mirax.cl/productos/n240001a250000/n243001a244000/n243701a243800/n243746.jpg"	"Maquetas"	29990	true	"Mirax Hobbies"	"https://www.mirax.cl/index.php?menu=271"	"HACHETTE"
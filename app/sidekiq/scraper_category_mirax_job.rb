# Step 3
# Enter the Parent category and browse the sub-categories

class ScraperCategoryMiraxJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, category, store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)

    # exist_sub_category = false
    unavailable_categories = ['Herramientas y accesorios', 'Otras pinturas', 'Pinturas', 'Juegos militares',
                              'Insumos para dioramas', 'Star wars legion', 'World of tanks']

    # change the category to a more correct one
    set_category = { 'Herramientas' => %w[Libros Accesorios herramientas] }

    # Get the host name
    uri = URI(url)

    # Get category UrL
    sub_category = doc.search('.category a').map do |element|
      "#{uri.host}/#{element.attr('href')}"
    end

    # Get category Category
    product_type = doc.search('.category p').map do |element|
      element.content
    end

    sub_category = sub_category.uniq
    product_type = product_type.uniq

    sub_category.each_with_index do |products, i|
      next unless unavailable_categories.exclude? product_type[i]

      # Loop through set_category to check that each of the categories corresponds
      set_category.each do |key, value|
        if value.include? product_type[i].split(' ')[0]
          category = key
          break
        end
      end

      # Check if the sub category contains other level of categories
      if products.include?('menu')
        # print("\n https://#{products} #{product_type[i]} y categoria #{category} \n")
        ScraperCategoryMiraxJob.perform_sync("https://#{products}", category, store_id) # async
      else
        # print("\n https://#{products} #{product_type[i]} y categoria #{category}")
        ScraperPaginationMiraxJob.perform_sync("https://#{products}", product_type[i], category, store_id)
      end
    end
  end
end
# Step 3

# Ya revisados --------------
# Pinturas, Efectos, Diluyentes Y Barnices -> acribilos y enamels tiene 2 niveles
# Maquetismo -> aviones y Helicopteros
# Maquetismo -> Gundam
# Miniaturas -> no tomar Juego militares, ni insumos para dioarmas, ni accesorios y herramientas, y pinturas
# Miniaturas -> Miniaturas games workshop y star wars legion son de 2 niveles IMPORTANTE LAS SUB CATEGORIAS ESTAN RARAS
# En miniaturas-> Pinturas se hace un bucle con https://www.mirax.cl/index.php?menu=1164 en "Otras pinturas"
# Pinturas Citadel tiene un 3 nivel por asi decirlom tal vez lo podemos manejar desde las miniaturas
# Miniaturas Games Workshop -> libros, hay que ver esto biem
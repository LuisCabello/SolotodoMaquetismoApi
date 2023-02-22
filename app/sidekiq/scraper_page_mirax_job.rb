# Step 2
# Scraper in charge of looking for the categories in which you can enter

class ScraperPageMiraxJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)

    unavailable_categories = ['Modelos armables de madera y otros', 'Modelos de papel y puzzles 3d',
                              'Accesorios y merchandising', 'Réplicas de animales y dinosaurios', 'Herramientas, pinceles y otros']

    category_key = ''

    #  normalize categories
    categories_values = {
      'Maquetas' => [],
      'Miniaturas' => [],
      'Pinturas' => [],
      'Herramientas' => []
    }
    categories_values['Maquetas'] << 'Aviones y helicópteros'
    categories_values['Maquetas'] << 'Autos, camiones y motos'
    categories_values['Maquetas'] << 'Soldados y blindados'
    categories_values['Maquetas'] << 'Ciencia ficción y series'
    categories_values['Maquetas'] << 'Soldados y carabineros metalicos'
    categories_values['Maquetas'] << 'Naves espaciales'
    categories_values['Maquetas'] << 'Barcos y submarinos'
    categories_values['Maquetas'] << 'Calcas y fotograbados'

    categories_values['Miniaturas'] << 'Miniaturas'

    categories_values['Pinturas'] << 'Pinturas, efectos, diluyentes y barnices'

    categories_values['Dioramas'] << 'Accesorios e insumos para dioramas'
    
    categories_values['Herramientas'] << 'Herramientas, pinceles y otros'
    categories_values['Herramientas'] << 'Libros de modelismo'
    categories_values['Herramientas'] << 'Aerógrafos y sus accesorios'
    categories_values['Herramientas'] << 'Pegamentos'
    categories_values['Herramientas'] << 'Otras herramientas'
    categories_values['Herramientas'] << 'Madera terciada y balsa'

    # Get the host name
    uri = URI(url)

    # Get category UrL
    category_url = doc.search('.category a').map do |element|
      "#{uri.host}/#{element.attr('href')}"
    end

    # Get the name of each category of the page
    categories = doc.search('.category p').map do |element|
      element.content
    end

    # Clear the variable of the repeated data.
    category_url = category_url.uniq
    categories = categories.uniq

    # Verify the category within those that are allowed and then we take its category name
    category_url.each_with_index do |product, i|
      next unless unavailable_categories.exclude? categories[i]

      # Check that the category URL is valid
      if product.blank?
        print("Skipping empty URL at index #{i}")
        next
      end

      # Check that the category name is valid
      category_name = categories[i].strip
      if category_name.blank?
        print("Skipping empty category name at index #{i}")
        next
      end

      categories_values.each do |key, value|
        if value.include?(category_name)
          category_key = key
          break
        end
      end

      
      # Check if category has subcategories
      if product.include?('menu')
        # print("\n Scraping https://#{product} con #{categories[i]} y store_id #{store_id}")
        # ScraperCategoryMiraxJob.perform_async("https://#{product}", category_key, store_id)
      else
        # there is no subcategory
        # print("\n Scraping https://#{product} con #{categories[i]} y store_id #{store_id}")
        ScraperPaginationMiraxJob.perform_sync("https://#{product}", categories[i], category_key, store_id) # async
      end 
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_page_mirax_job Step 2 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
# Step 2
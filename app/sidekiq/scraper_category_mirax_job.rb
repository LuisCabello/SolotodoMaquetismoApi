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
        ScraperCategoryMiraxJob.perform_async("https://#{products}", category, store_id) # async
      else
        ScraperPaginationMiraxJob.perform_async("https://#{products}", product_type[i], category, store_id)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_category_mirax_job Step 3 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
# Step 3
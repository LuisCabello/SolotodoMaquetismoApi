# Step 2
# Scraper in charge of looking for the categories in which you can enter
class ScraperPageMiraxJob
  include Sidekiq::Job
  include MiraxHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)

    unavailable_categories = ['Modelos armables de madera y otros', 'Modelos de papel y puzzles 3d',
                              'Accesorios y merchandising', 'Réplicas de animales y dinosaurios', 'Herramientas, pinceles y otros']

    category_key = ''

    # Set the values for the categories
    categories_values = category_values

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
        ScraperCategoryMiraxJob.perform_async("https://#{product}", category_key, store_id)
      else
        print category_key
        # there is no subcategory
        ScraperPaginationMiraxJob.perform_async("https://#{product}", categories[i], category_key, store_id)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_page_mirax_job Step 2 : #{e.message}\n#{e.backtrace.join("\n")}"
  end
end
# Step 2
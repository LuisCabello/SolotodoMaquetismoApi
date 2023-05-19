# Step 2
# Scraper in charge of looking for the categories in which you can enter
class ScraperPageMiraxJob
  include Sidekiq::Job
  include MiraxHelper
  include UtilitiesHelper

  require 'nokogiri'
  require 'open-@uri'
  require 'json'

  def perform(url, _store_id)
    @doc = parsing_html(url)

    # Get the host name
    @uri = URI(url)

    @unavailable_categories = ['Modelos armables de madera y otros', 'Modelos de papel y puzzles 3d',
                               'Accesorios y merchandising', 'Réplicas de animales y dinosa@urios', 'Herramientas, pinceles y otros']

    # Set the values for the categories
    categories_values = MiraxHelper.category_values

    # Get category UrL
    category_url = all_category_url

    # Get the name of each category of the page
    categories = all_categories_names

    verify_all_categories(category_url, categories, categories_values)
  rescue StandardError => e
    Rails.logger.error "Error en scraper_page_mirax_job Step 2 : #{e.message}\n#{e.backtrace.join("\n")}"
  end

  def all_category_url
    @doc.search('.category a').map do |element|
      "#{@uri.host}/#{element.attr('href')}"
    end
  end

  def all_categories_names
    # @doc.search('.category p').map do |element|
    #   element.content
    # end
    @doc.search('.category p').map(&:content)
  end

  def verify_all_categories(category_url, categories, categories_values)
    # Clear the variable of the repeated data.
    category_url = category_url.uniq
    categories = categories.uniq

    # Verify the category within those that are allowed and then we take its category name
    category_url.each_with_index do |product, i|
      next unless @unavailable_categories.exclude? categories[i]

      # Check that the category URL is valid
      next if product.blank?

      # Check that the category name is valid
      category_name = categories[i].strip
      next if category_name.blank?

      category_key = category_key(categories_values, category_name)
      scraping(product, category_key, store_id, categories[i])
    end
  end

  def category_key(categories_values, category_name)
    categories_values.each do |key, value|
      return key if value.include?(category_name)
    end
  end

  def scraping(product, category_key, store_id, categories)
    # Check if category has subcategories
    if product.include?('menu')
      ScraperCategoryMiraxJob.perform_async("https://#{product}", category_key, store_id)
    else
      # there is no subcategory
      ScraperPaginationMiraxJob.perform_async("https://#{product}", categories, category_key, store_id)
    end
  end
end
# Step 2

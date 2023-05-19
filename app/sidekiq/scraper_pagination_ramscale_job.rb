# Step 3
# Takes all the products of the sub-category and walks through them, including the pagination
class ScraperPaginationRamscaleJob
  include Sidekiq::Job
  include UtilitiesHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, category_id, category_name, brand, type, store_id)
    @doc = parsing_html(url)
    page_num = 2

    # Get the host name
    @uri = URI(url)

    # Get products UrL
    products = products_url

    # Get number of pages
    number_pages = number_of_pages

    # the while loop runs as long as the statement is iqual to te max number of pages
    all_products_pagination(page_num, number_pages, products)

    # Loop whit the products
    scraper_products(products, category_id, category_name, type, store_id, brand)
  rescue StandardError => e
    Rails.logger.error "Error en scraper_pagination_ramscale_job Step 3 : #{e.message}\n#{e.backtrace.join("\n")}"
  end

  def products_url
    @doc.search('.product-item__image-wrapper').map do |element|
      "#{@uri.host}#{element.attr('href')}"
    end
  end

  def number_of_pages
    number_pages = ''
    @doc.search('.pagination__nav-item').map do |element|
      number_pages = element.text
    end
    number_pages
  end

  def next_page_url
    next_page = ''
    @doc.search('.pagination__next').map do |element|
      next_page = "https://#{@uri.host}/#{element.attr('href')}"
    end
    next_page
  end

  def all_products_pagination(page_num, number_pages, products)
    while page_num <= number_pages.last.to_i
      # Get the url of the next page
      next_page = next_page_url
      @doc = parsing_html(next_page.to_s)

      # Get products UrL
      products += products_url
      page_num += 1
    end
  end

  def scraper_products(products, category_id, category_name, type, store_id, brand)
    products.each do |product|
      ScraperProductRamscaleJob.perform_sync("https://#{product}", category_id, category_name, type, store_id, brand)
      break
    end
  end
end

# Step 4

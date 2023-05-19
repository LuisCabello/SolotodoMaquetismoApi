# Step 4
# Takes all the products of the sub-category and walks through them, including the pagination
class ScraperPaginationMiraxJob
  include Sidekiq::Job
  include UtilitiesHelper

  require 'nokogiri'
  require 'open-@uri'
  require 'json'

  def perform(url, type, category_key, store_id)
    @doc = parsing_html(url)

    # Get the host name
    @uri = URI(url)

    # Get products UrL
    products = all_products_url

    products_by_page

    # Loop whit the products
    products.each do |product|
      ScraperProductJob.perform_async("https://#{product}", type, category_key, store_id)
    end
  rescue StandardError => e
    Rails.logger.error "Error en scraper_pagination_mirax_job Step 4 : #{e.message}\n#{e.backtrace.join("\n")}"
  end

  def all_products_url
    @doc.search('.tile-producto a').map do |element|
      "#{@uri.host}/#{element.attr('href')}"
    end
  end

  def number_of_pages
    @doc.search('.selector_pagina option').map do |element|
      element.attr('value')
    end
  end

  def products_by_page
    page_num = 2

    # Get number of pages
    number_pages = number_of_pages

    # The while loop runs as long as the statement is iqual to te max number of pages
    while page_num <= number_pages.last.to_i
      # Get the url of the next page
      next_page = next_page_url

      @doc = parsing_html(next_page.to_s)

      # Get products UrL
      products += all_products_url
      page_num += 1
    end
  end

  def next_page_url
    @doc.search('.fa-angle-right').map do |element|
      "https://#{@uri.host}/#{element.attr('href')}"
    end
  end
end
# Step 4

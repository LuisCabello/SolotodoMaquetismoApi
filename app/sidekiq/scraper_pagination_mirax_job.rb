# Step 4
# Takes all the products of the sub-category and walks through them, including the pagination
class ScraperPaginationMiraxJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, type, category_key, store_id)
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)
    next_page = ''
    page_num = 2

    # Get the host name
    uri = URI(url) # Deberia ser una variable de pagina

    # Get products UrL
    products = doc.search('.tile-producto a').map do |element|
      "#{uri.host}/#{element.attr('href')}"
    end

    # Get number of pages
    number_pages = doc.search('.selector_pagina option').map do |element|
      element.attr('value')
    end
    # number_pages = number_pages.uniq
    # number_pages.last

    # the while loop runs as long as the statement is iqual to te max number of pages
    while page_num <= number_pages.last.to_i
      # Get the url of the next page
      doc.search('.fa-angle-right').map do |element|
        next_page = "https://#{uri.host}/#{element.attr('href')}"
      end

      html = URI.open(next_page.to_s).read
      doc = Nokogiri::HTML(html)

      # Get products UrL
      products += doc.search('.tile-producto a').map do |element|
        "#{uri.host}/#{element.attr('href')}"
      end
      page_num += 1
    end

    # Loop whit the products
    products.each do |product|
      print("\n URL : https://#{product} con tipo : #{type} con categoria : #{category_key} y store id : #{store_id}")
      # ScraperProductJob.perform_async("https://#{product}", type, category_key, store_id)
      # perform_async
    end
  end
end
# Step 4

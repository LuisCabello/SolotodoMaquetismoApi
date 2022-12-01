# Paso 3
# Entra a la categoria Padre y recorre las sub-categorias

class ScraperCategoryMiraxJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'csv'

  def perform(url)
    # html  = URI.open("https://www.mirax.cl/index.php?menu=300").read
    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)

    # Get the host name
    uri = URI(url) # Deberia ser una variable de pagina

    # Get category UrL
    products = doc.search('.category a').map do |element|
      "#{uri.host}/#{element.attr('href')}"
    end

    # # Get category Category
    # categories = doc.search('.category p').map do |element|
    #   element.content
    # end

    products = products.uniq
    # categories = categories.uniq

    # categories.each do |product|
    #   print("\n" + product + "\n")
    # end

    # products.each_with_index do |product, i|
    #   ScraperPaginationMiraxJob.perform_async("https://#{product}", categories[i])
    # end

    products.each do |product|
      ScraperPaginationMiraxJob.perform_async("https://#{product}")
    end
  end
end
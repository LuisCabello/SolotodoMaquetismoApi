require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

# Tener en cuenta que para manejar las categorias, se puede hacer aqui, ver cuales son las que queremos y finalmente setear la categoria para que calse con 
# Las categorias en labase

# Tal vez buscar todos los href que tenan la palabra categoria en ella

# Categorias de interes : 
# aviones y Helicopte 

html  = URI.open("https://www.mirax.cl/index.php?menu=300").read
doc   = Nokogiri::HTML(html)

# Get the host name
uri = URI('https://www.mirax.cl/index.php?menu=300') # Deberia ser una variable de pagina

# Get category UrL
products = doc.search('.category a').map do |element|
  "#{uri.host}/#{element.attr('href')}"
end

products = products.uniq

products.each do |product|
  ScraperPaginationMiraxJob.perform_async("https://#{product}")
end
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

# html  = URI.open("https://www.mirax.cl/detalles.php?codigo=32449").read
html  = URI.open("https://www.mirax.cl/detalles.php?codigo=251969").read
doc   = Nokogiri::HTML(html)
image = ""

# Hash to save data
product = {"name" => " ", "price" => " ", "offer_price" => " ", "type" => " ", "image" => " ", "creation_date" => " ", "category" => " ", "brand" => " " }
products_headers = ["name", "price", "offer_price", "type", "image", "creation_date", "category", "brand"]


# Hash to save json description data
description = {"description" => "", "scale" => ""}

doc.search('.row h1').map do |element|
  product["name"] = element.inner_text.strip
end

doc.search('.price').map do |element|
  product["price"] = element.inner_text.strip
end

# Description for the json
doc.search('.p-style4').map do |element|
  description["description"] = element.inner_text.strip
end

# # Hay que pasarlas a un jsonb
# # categoria, tipo, escala 
# doc.search('.breadcrumb').map do |element|
#   element.inner_text.strip
# end

# Get Img UrL
doc.css('img').map do |element|
  image = element.attr('src')
  if image.include?('productos')
    break
  end
end

# Get the host name
# uri = URI('https://www.mirax.cl/detalles.php?codigo=32449') # Deberia ser una variable de pagina
uri = URI('https://www.mirax.cl/detalles.php?codigo=251969') # Deberia ser una variable de pagina
product["image"] = "#{uri.host}/#{image}"

# Get the creation date
time = Time.new
values = time.to_a
product["creation_date"] = Time.utc(*values)

nameProduct = product["name"]

# Get the brand
brand = nameProduct.partition(" ").first

# String to array
nameProduct = nameProduct.split

# Get the scale
nameProduct.each do |x|
  if x.include?(':')
    description["scale"] = x
    break
  end
end

# Clean the name of the product
nameProduct.delete_if {|x| x.include?(":") }
nameProduct.delete_if {|x| x.include?(brand) }

# Final name of the product
nameProduct = nameProduct.join(" ")
product["name"] = nameProduct

# if there is no data it is not shown
description = description.to_json

# Take the product and save it into the csv file
valores = product.values
csv_table = CSV.table("products.csv")
 
# check that the file is empty
if csv_table.count <= 0
  CSV.open("products.csv", "a+",  write_headers: true, headers: products_headers) do |csv|
    csv << valores
  end
else
  CSV.open("products.csv", "a+") do |csv|
    csv << valores
  end
end

# ruby D:\Estudio\SolotodoMaquetismoApi\app\jobs\scraper_product.rb
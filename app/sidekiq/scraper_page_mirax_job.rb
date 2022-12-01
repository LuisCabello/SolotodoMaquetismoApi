# Paso 2
# Scraper encargado de buscar a las categorias en las que se puede ingresar

class ScraperPageMiraxJob
  include Sidekiq::Job

  require 'nokogiri'
  require 'open-uri'
  require 'json'
  require 'csv'

  def perform(url)

    html  = URI.open(url).read
    doc   = Nokogiri::HTML(html)

    available_categories = ["Autos, camiones y motos","Soldados y blindados"]

    # Get the host name
    uri = URI(url) # Deberia ser una variable de pagina

    # Get category UrL
    category_urL = doc.search('.category a').map do |element|
      "#{uri.host}/#{element.attr('href')}"
    end

    # Get category Category
    categories = doc.search('.category p').map do |element|
      element.content
    end

    category_urL = category_urL.uniq
    categories = categories.uniq

    # Check the category
    category_urL.each_with_index do |product, i|
      if(available_categories.include? categories[i])
        ScraperCategoryMiraxJob.perform_async("https://#{product}")
      end
    end
  end
end

 # Categorias permitidas
    # -Aviones y Helicopteros ✓
    # -Autos, camiones y motos ✓
    # -Soldados y Blindados ✓
    # -Ciencia ficcion y Series ✓
    # -Miniaturas ✓
    # -Solados y Carabineros Metalicos (si se puede, tal vez dejarlos como soldados en vez de carabineros o algo asi) ✓
    # -Pinturas, efectos, diluyentes y barnices ✓
    # -Accesorios e insumos para dioramas (Tal vez dejarlo como solo dioramas)✓
    # -Herramientas, pincels y otros ✓
    # -Naves Espaciales ✓
    # -Barcos y Submarinos ✓
    # -Modelos Armables de Madera y otros (Tal vez no, hay que ver) ✓ 
    # -Modelos de papel y Puzzles 3d (Probablemente no)
    # -Libros de Modelismo (Tal vez si, pero dentro de las herramientas tal vez) ✓
    # -Aerografos y sus accesorios (Tal vez dejarlo dentro de herramientas)✓
    # -Pegamentos (Tal vez dejarlo dentro de herramientas)✓
    # -Otras herramientas (dejarlas dentro de herramientas) ✓
    # -Calcas y fotograbados ✓
    # -Accesorios y Merchandising (Probablemente no)
    # -Madera Terciada y balsa ✓ (Tal vez si, dejarlo en herramientas)
    # -Replicas de animales y dinosaurios (Probablemente no, tiene que ver mas con juguetes que con modelos)

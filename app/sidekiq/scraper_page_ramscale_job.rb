# Step 2
# Scraper in charge of looking for the categories in which you can enter
class ScraperPageRamscaleJob
  include Sidekiq::Job
  include UtilitiesHelper
  include RamscaleHelper

  require 'nokogiri'
  require 'open-uri'
  require 'json'

  def perform(url, store_id)
    @doc = parsing_html(url)

    # Get the host name
    @uri = URI(url)

    @unavailable_categories = ['Juegos de Mesa']
    @special_sub_categories = ['tanques', 'aviones', 'barcos', 'sci fi y civiles', 'figuras y accesorios']
    categories_and_types = {}

    product_url_base = scraping_categories_types(categories_and_types).first

    # get the brands/types
    brand_types = scraping_brand_types

    # Set the type or the brand for the category
    organize_type_brand_for_category(categories_and_types, brand_types)

    # The categories are traversed and for each sub_categories we obtain the types and save them
    types_for_sub_categories(categories_and_types)

    # Start browsing the categories
    scrapign_categories(store_id, categories_and_types, product_url_base)
  end

  def scraping_brand_types
    @doc.search('.mega-menu__title').map do |element|
      element['href'].split('/').last.gsub('-', ' ')
    end
  end

  def scraping_categories_types(categories_and_types)
    @doc.css('.nav-bar__link.link').map do |element|
      categories_and_types[element.text.strip] = {}
    end

    @doc.css('.nav-bar__link.link').map do |element|
      element.attr('href')
    end
  end

  def organize_type_brand_for_category(categories_and_types, brand_types)
    categories_and_types.each do |key, _value|
      brand_types.each do |element|
        if element.include? key.downcase
          organize_for_category(categories_and_types, key, element)
        elsif (key.include? 'Maquetas') && (@special_sub_categories.include? element)
          organize_for_category(categories_and_types, key, element)
        end
      end
    end
  end

  def organize_for_category(categories_and_types, key, element)
    categories_and_types[key][element.gsub(key.downcase, '').strip] = ''
  end

  def types_for_sub_categories(categories_and_types)
    category_number = 0

    categories_and_types.each_with_index do |categories, _i|
      category_number += 1
      next unless @unavailable_categories.exclude? categories[0]

      # Extract the hash of the array by removing the sub_categories
      sub_categories = categories.last

      # Extract the keys from the hash
      sub_categories = sub_categories.keys

      # Scraping all the categories and associates them with the sub categories
      scraping_types_categories(category_number, sub_categories, categories, categories_and_types)
    end
  end

  def scraping_types_categories(category_number, sub_categories, categories, categories_and_types)
    types = ''
    sub_arrays_by_category = ''

    @doc.search("#desktop-menu-0-#{category_number}").map do |element|
      types = element.inner_text.strip

      # Set the Array and the internal elements (spaces and empty elements are removed)
      types = normalize_types(types)
      sub_arrays_by_category = categorize_array(types, sub_categories)

      # associate the types with their respective categories
      associate_types_categories(sub_arrays_by_category, categories, categories_and_types)

      break
    end
  end

  def normalize_types(types)
    types = types.split("\n")

    types = correct_types(types)

    # Clean the voids
    types.reject!(&:empty?)

    # set the data to be a compatible url
    types.map! { |item| item.parameterize.gsub('-', ' ') }
  end

  # Some types are misspelled on the website
  def correct_types(types)
    types.each_with_index do |elemento, i|
      types[i] = if elemento.include?('Buques')
                   'Barcos'
                 elsif elemento.include?('Bordermodel')
                   'Bodermodel'
                 else
                   elemento.strip
                 end
    end
  end

  def associate_types_categories(sub_arrays_by_category, categories, categories_and_types)
    sub_arrays_by_category.each do |key, value|
      categories_and_types[categories[0]][key.downcase] = value
    end
  end

  # Gets all the types and separates them by subcategories
  def categorize_array(types, sub_categories)
    sub_arrays = []
    sub_arrays_by_category = {}

    # Loop through the categories and save in a sub_array only the sub categories
    types.each { |item| sub_categories.include?(item.downcase) ? sub_arrays << [] : sub_arrays.last << item }

    # Set the categories with the corresponding types
    sub_categories.each_with_index do |category, index|
      sub_arrays_by_category[category] = sub_arrays[index]
    end

    sub_arrays_by_category
  end

  def scrapign_categories(store_id, categories_and_types, product_url_base)
    all_categories = Category.getCategories
    # TODO: Revisar esto, esta raro llamar asi al metodo
    categories_values = RamscaleHelper.category_values

    categories_and_types.each do |category, sub_categories|
      next unless @unavailable_categories.exclude? category

      category = normalize_categories(category, categories_values)
      category_id = category_by_name(category, all_categories)
      scraping_pagination_products(sub_categories, category, product_url_base, store_id, category_id)
      # break
    end
  end

  def normalize_categories(category_name, categories_values)
    category_key = ''
    categories_values.each do |key, value|
      if value.include?(category_name)
        category_key = key
        break
      end
    end
    category_key
  end

  def category_by_name(category, all_categories)
    all_categories.find { |c| c.name == category }
  end

  def scraping_pagination_products(sub_categories, category, product_url_base, store_id, category_id)
    sub_categories&.each do |sub_category, products|
      products&.each do |product|
        product_url_final = create_url_final(category, sub_category, product, product_url_base)
        response = url_exists?(product_url_final)
        if response
          # print("\n Prueba #{product_url_final} - #{category_id.id} - #{category} - #{sub_category} - #{product} - #{store_id} \n")
          ScraperPaginationRamscaleJob.perform_sync(product_url_final, category_id.id, category, sub_category, product,
                                                    store_id)
        else
          response = url_exists?("#{@uri}#{product_url_base.split('/')[1]}/#{product.parameterize}")
          if response
            ScraperPaginationRamscaleJob.perform_sync(product_url_final, category_id.id, category, sub_category, product,
                                                      store_id)
          end
        end
        break
      end
      break
    end
  end

  def create_url_final(category, sub_category, product, product_url_base)
    product_name = category == 'Maquetas' ? "#{sub_category} #{product}" : "#{product} #{sub_category}"
    product_url_final = product_name.parameterize
    "#{@uri}#{product_url_base.split('/')[1]}/#{product_url_final}"
  end
end
# Step 2

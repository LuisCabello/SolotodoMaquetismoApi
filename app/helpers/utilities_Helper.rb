module UtilitiesHelper

  def parsing_html(url) 
    html = URI.open(url).read
    Nokogiri::HTML(html)
  end

  def url_exists?(url)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    response = http.request_head(url.path)
    response.code != '404'
  end

  # Clean the name, delete the scale( : and / )
  def clean_scale(product)
    product['name'].gsub(/(\w+:\d+)/, '').gsub(%r{(?<word>\w*/\d+)\s}, '').strip
  end

  # Delete the brand
  def clean_brand(product, brand_name, data)
    product[data].gsub(brand_name, '').gsub(/\s{2,}/, ' ').strip
  end

  # Get the scale from the product or the description
  def get_scale(hash, key)
    (/(\w+:\d+)/.match(hash[key].to_s) || %r{(?<word>\w*/\d+)\s}.match(hash[key]).to_s.gsub('/', ':'))
  end
end
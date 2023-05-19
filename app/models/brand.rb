class Brand < ApplicationRecord
  has_and_belongs_to_many :products

  # Crud

  # Get the brand by name, if is not defined then is "Others"
  def self.getBrandByName(brand_name)
    brand = Brand.find_by(name: brand_name)

    if !brand
      Brand.find_by(name: 'OTROS')
    else
      brand
    end
  end
end

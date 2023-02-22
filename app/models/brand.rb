class Brand < ApplicationRecord
  has_and_belongs_to_many :products

  # Crud

  def getBrandByName(brand_name)
    Brand.find_by(name: brand_name)
  end
end

class Product < ApplicationRecord
  has_and_belongs_to_many :brands

  # intermediate table
  has_many :prices
  has_many :stores, through: :prices

  has_one :category

  # alows to use the "type" word in the table
  self.inheritance_column = :foo
  attr_accessor :type

  # Model Crud
  def self.addProduct(product, description)
    final_product = Product.new
    final_product.name = product['name']
    final_product.characteristic = description.to_json
    final_product[:type] = product['type']
    final_product.image = product['image']
    final_product.creation_date = product['creation_date']
    final_product.category_id = product['category_id']
    final_product.save
    final_product
  end
end

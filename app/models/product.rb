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
  def addProduct(name, description, type, image, creation_date, category_id)
    final_product = Product.new
    final_product.name = name
    final_product.characteristic = description.to_json
    final_product[:type] = type
    final_product.image = image
    final_product.creation_date = creation_date
    final_product.category_id = category_id
    final_product.save
    final_product
  end
end

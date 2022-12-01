class Store < ApplicationRecord
  has_and_belongs_to_many :products
  # intermediate table
  has_many :prices
  has_many :products, through: :prices
end

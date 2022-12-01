class Product < ApplicationRecord
  has_and_belongs_to_many :brands

  # intermediate table
  has_many :prices
  has_many :stores, through: :prices

  has_one :category

  # alows to use the "type" word in the table
  self.inheritance_column = :foo
  attr_accessor :type
end
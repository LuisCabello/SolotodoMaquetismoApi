class Category < ApplicationRecord
  has_many :products
  has_many :Category_lists
end

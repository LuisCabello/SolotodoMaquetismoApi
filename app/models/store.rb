class Store < ApplicationRecord
  has_and_belongs_to_many :products
  # intermediate table
  has_many :prices
  has_many :products, through: :prices

  # GET Stores
  def getStores
    Store.all
  end

  # return the first store by name
  def self.get_store_by_name(name_category)
    Store.find_by(name: name_category)
  end
end

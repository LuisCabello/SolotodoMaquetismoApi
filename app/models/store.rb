class Store < ApplicationRecord
  has_and_belongs_to_many :products
  # intermediate table
  has_many :prices
  has_many :products, through: :prices

  # CRUD
  # GET Stores
  def getStores
    Store.all
  end

  # return the first store by name
  def getStoreyByName(name_category)
    Store.find_by(name: name_category)
  end

end

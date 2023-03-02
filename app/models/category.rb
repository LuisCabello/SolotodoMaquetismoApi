class Category < ApplicationRecord
  has_many :products
  has_many :category_lists

  # return a collection with all categories
  def getCategories
    Category.all
  end

  # return the first category by name
  def getCategoryByName(name_category)
    Category.find_by(name: name_category)
  end

end

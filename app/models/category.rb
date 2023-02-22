class Category < ApplicationRecord
  has_many :products
  has_many :category_lists

  # crud ORM

  # Create
  # user = User.new
  # user.name = "David"
  # user.occupation = "Code Artist"
  # user.save

  # Read
  # return a collection with all categories
  def getCategories
    Category.all
  end

  # return the first user
  # user = User.first

  # return the first user named David
  def getCategoryByName(name_category)
    Category.find_by(name: name_category)
  end

  # find all users named David who are Code Artists and sort by created_at in reverse chronological order
  # users = User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
end

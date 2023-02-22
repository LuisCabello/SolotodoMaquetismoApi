class CategoryListsController < ApplicationController
  # show the categorie_list, return a Json
  def index
    render json: CategoryList.all
  end

  # show one category_list according to id, return a Json
  def show
    if CategoryList.exists?(params[:id])
      category_list = CategoryList.find(params[:id])
      render json: category_list
    else
      render json: { message: 'category_list not found' }, status: :ok
    end
  end

  # Create category_list
  def create
    category_list = CategoryList.create(category_list_params)

    if category_list.errors.present?
      render json: { error: category_list.errors }, status: :unprocessable_entity
    else
      render json: { message: 'category_list saved successfully', result: category_list }, status: :created
    end
  end

  # Take the category_list for an id, and update the attributes with the ones passed to it by parameters
  def update
    category_list = CategoryList.find(params[:id])
    category_list.update(category_list_params)
    render json: category_list
  end

  # destroy a category_list with an id
  def destroy
    CategoryList.destroy(params[:id])
  end

  # serves as protection
  private

  def category_list_params
    params.require(:category_list).permit(:category_id)
  end
end

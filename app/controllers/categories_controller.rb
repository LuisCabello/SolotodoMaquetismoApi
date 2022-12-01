class CategoriesController < ApplicationController
  # show the categories, return a Json
  def index
    render json: Category.all
  end

  # show one category according to its id, return a Json
  def show
    if Category.exists?(params[:id])
      category = Category.find(params[:id])
      render json: category
    else
      render json: { message: 'Category not found' }, status: :ok
    end
  end

  # Create category
  def create
    category = Category.create(category_params)

    if category.errors.present?
      render json: { error: category.errors }, status: :unprocessable_entity
    else
      render json: { message: 'Category saved successfully', result: category }, status: :created
    end
  end

  # Take the category for an id, and update the attributes with the ones passed to it by parameters
  def update
    category = Category.find(params[:id])
    category.update(category_params)
    render json: category
  end

  # destroy a category with an id
  def destroy
    Category.destroy(params[:id])
  end

  # serves as protection
  private

  def category_params
    params.require(:category).permit(:name)
  end
end

# Tenemos Categorias que sera mas amplio que el tipo 

# Ej : Category "Maqueta" -> blindados, figuras etc
# Ej : Category "Herramientas" -> tipos de herramientas
# Ej : Category "pinturas" -> tipos de pinturas


class BrandsController < ApplicationController
  # show the categories, return a Json
  def index
    render json: Brand.all
  end

  # show one category according to its id, return a Json
  def show
    if Brand.exists?(params[:id])
      brand = Brand.find(params[:id])
      render json: brand
    else
      render json: { message: 'Brand not found' }, status: :ok
    end
  end

  # Create category
  def create
    brand = Brand.create(brand_params)

    if brand.errors.present?
      render json: { error: brand.errors }, status: :unprocessable_entity
    else
      render json: { message: 'Brand saved successfully', result: brand }, status: :created
    end
  end

  # Take the category for an id, and update the attributes with the ones passed to it by parameters
  def update
    brand = Brand.find(params[:id])
    brand.update(brand_params)
    render json: brand
  end

  # destroy a category with an id
  def destroy
    Brand.destroy(params[:id])
  end

  # serves as protection
  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end

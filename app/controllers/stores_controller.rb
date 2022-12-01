class StoresController < ApplicationController
  # show the stores, return a Json
  def index
    render json: Store.all
  end

  # show one store according to its id, return a Json
  def show
    if Store.exists?(params[:id])
      store = Store.find(params[:id])
      render json: store
    else
      render json: { message: 'Store not found' }, status: :ok
    end
  end

  # Create store
  def create
    store = Store.create(store_params)

    if store.errors.present?
      render json: { error: store.errors }, status: :unprocessable_entity
    else
      render json: { message: 'Store saved successfully', result: store }, status: :created
    end
  end

  # Take the store for an id, and update the attributes with the ones passed to it by parameters
  def update
    store = Store.find(params[:id])
    store.update(store_params)
    render json: store
  end

  # destroy a store with an id
  def destroy
    Store.destroy(params[:id])
  end

  # serves as protection
  private

  def store_params
    params.require(:store).permit(:name, :url)
  end
end

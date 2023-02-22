class Price < ApplicationRecord
  belongs_to :store , foreign_key: 'store_id'
  belongs_to :Product , foreign_key: 'product_id'

  # Crud
  def addPrice(product_id, store_id, amount, offer_amount, current_amount)
    final_price = Price.new
    final_price.product_id = product_id
    final_price.store_id = store_id
    final_price.amount = amount
    final_price.offer_amount = offer_amount
    final_price.current_amount = current_amount
    final_price.save
    final_price
  end

end

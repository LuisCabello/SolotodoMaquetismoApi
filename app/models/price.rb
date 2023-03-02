class Price < ApplicationRecord
  belongs_to :store , foreign_key: 'store_id'
  belongs_to :Product , foreign_key: 'product_id'

  # Crud
  def addPrice(product_id, price)
    final_price = Price.new
    final_price.product_id = product_id
    final_price.store_id =  price['store_id']
    final_price.amount = price['amount'].delete('^0-9').to_i
    final_price.offer_amount = price['offer_amount']
    final_price.current_amount = price['current_amount']
    final_price.save
    final_price
  end

end

class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.integer :product_id
      t.integer :store_id
      t.integer :amount
      t.integer :offer_amount
      t.boolean :current_amount

      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :category_id
      t.string :name
      t.jsonb :characteristic
      t.string :type
      t.string :image
      t.date :creation_date

      t.timestamps
    end
  end
end

class CreateJoinTableBrandsProducts < ActiveRecord::Migration[7.0]
  def change
    create_join_table :brands, :products do |t|
    end
  end
end

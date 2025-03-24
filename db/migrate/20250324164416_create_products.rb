class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.boolean :on_sale
      t.decimal :sale_price
      t.string :sku

      t.timestamps
    end
  end
end

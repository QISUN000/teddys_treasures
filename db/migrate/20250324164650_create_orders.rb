class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.decimal :subtotal
      t.decimal :gst_rate
      t.decimal :pst_rate
      t.decimal :hst_rate
      t.decimal :gst_amount
      t.decimal :pst_amount
      t.decimal :hst_amount
      t.decimal :total

      t.timestamps
    end
  end
end

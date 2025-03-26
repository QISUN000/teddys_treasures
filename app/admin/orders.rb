# app/admin/orders.rb
ActiveAdmin.register Order do
  permit_params :status

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total do |order|
      number_to_currency(order.total/100.0)
    end
    column :created_at
    actions
  end

  filter :user
  filter :status
  filter :created_at

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :subtotal do |order|
        number_to_currency(order.subtotal/100.0)
      end
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :gst_amount do |order|
        number_to_currency(order.gst_amount/100.0)
      end
      row :pst_amount do |order|
        number_to_currency(order.pst_amount/100.0)
      end
      row :hst_amount do |order|
        number_to_currency(order.hst_amount/100.0)
      end
      row :total do |order|
        number_to_currency(order.total/100.0)
      end
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price_at_purchase do |item|
          number_to_currency(item.price_at_purchase/100.0)
        end
        column :total do |item|
          number_to_currency(item.price_at_purchase * item.quantity/100.0)
        end
      end
    end
  end
end
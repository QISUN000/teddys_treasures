ActiveAdmin.register Order do
  permit_params :status

  scope :all
  scope :pending
  scope :paid
  scope :shipped
  scope :delivered
  scope :cancelled

  filter :id
  filter :user_email, as: :string, label: 'Customer Email'
  filter :created_at
  filter :status, as: :select, collection: Order.statuses

  index do
    selectable_column
    id_column
    column :user do |order|
      link_to order.user.email, admin_user_path(order.user) if order.user
    end
    column :status do |order|
      status_tag order.status, class: order_status_class(order.status)
    end
    column :total do |order|
      number_to_currency(order.total/100.0)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status do |order|
        status_tag order.status, class: order_status_class(order.status)
      end
      row :payment_id
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

  form do |f|
    f.inputs "Order Details" do
      f.input :status, as: :select, collection: Order.statuses.keys.map { |s| [s.humanize, s] }
    end
    f.actions
  end

  # Define a custom action to change status quickly
  action_item :mark_as_shipped, only: :show, if: proc { resource.paid? } do
    link_to 'Mark as Shipped', mark_as_shipped_admin_order_path(resource), method: :put
  end

  member_action :mark_as_shipped, method: :put do
    order = Order.find(params[:id])
    order.shipped!
    redirect_to admin_order_path(order), notice: 'Order marked as shipped.'
  end

  action_item :mark_as_delivered, only: :show, if: proc { resource.shipped? } do
    link_to 'Mark as Delivered', mark_as_delivered_admin_order_path(resource), method: :put
  end

  member_action :mark_as_delivered, method: :put do
    order = Order.find(params[:id])
    order.delivered!
    redirect_to admin_order_path(order), notice: 'Order marked as delivered.'
  end

  action_item :mark_as_cancelled, only: :show, if: proc { !resource.cancelled? } do
    link_to 'Cancel Order', mark_as_cancelled_admin_order_path(resource), method: :put, data: { confirm: 'Are you sure you want to cancel this order?' }
  end

  member_action :mark_as_cancelled, method: :put do
    order = Order.find(params[:id])
    order.cancelled!
    redirect_to admin_order_path(order), notice: 'Order has been cancelled.'
  end

  # Helper method for status colors
  controller do
    def order_status_class(status)
      case status
      when 'pending'
        'warning'
      when 'paid'
        'success'
      when 'shipped'
        'info'
      when 'delivered'
        'success'
      when 'cancelled'
        'error'
      end
    end
    helper_method :order_status_class
  end
end
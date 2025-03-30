ActiveAdmin.register Order do

  permit_params :status


  batch_action :destroy, confirm: "Are you sure you want to delete these orders?" do |ids|
    Order.where(id: ids).destroy_all
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} orders"
  end
  
  batch_action :update_status, form: {
    status: %w[pending processing shipped delivered cancelled]
  } do |ids, inputs|
    Order.where(id: ids).update_all(status: inputs[:status])
    redirect_to collection_path, notice: "Successfully updated status for #{ids.count} orders"
  end
  
  # Load all orders for the custom template
  controller do
    def index
      @orders = Order.all.includes(:user)
      @users_with_orders = User.joins(:orders)
                               .distinct
                               .includes(orders: {order_items: :product})
      render 'admin/orders/index'
    end
  end
end
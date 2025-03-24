ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.order(created_at: :desc).limit(5) do
            column("Status") { |order| status_tag order.status }
            column("Customer") { |order| link_to(order.user.email, admin_user_path(order.user)) }
            column("Total") { |order| number_to_currency(order.total/100.0) }
            column("Date") { |order| order.created_at.strftime("%b %d, %Y") }
            column("") { |order| link_to("View", admin_order_path(order)) }
          end
          para link_to "View All Orders", admin_orders_path
        end
      end
      
      column do
        panel "Product Statistics" do
          div class: "stat_container" do
            h3 Product.count
            para "Total Products"
          end
          
          div class: "stat_container" do
            h3 Product.where(on_sale: true).count
            para "On Sale Products"
          end
          
          div class: "stat_container" do
            h3 Product.where("stock_quantity < 5").count
            para "Low Stock"
          end
        end
      end
    end
  end
end
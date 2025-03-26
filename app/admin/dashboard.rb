# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Recent Products" do
          ul do
            Product.order(created_at: :desc).limit(5).map do |product|
              li link_to(product.name, admin_product_path(product))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to the Teddy's Treasures admin interface."
        end
      end
    end
  end
end
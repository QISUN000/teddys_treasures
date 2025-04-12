class ApplicationController < ActionController::Base
  before_action :set_categories
  before_action :track_user_activity
  helper_method :current_cart, :cart_count, :cart_total, :last_visit
  
  # For Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])
  end
  
  def set_categories
    @categories = Category.all
  end
  
  # Custom flash types
  add_flash_types :error, :info, :warning
  
  # Track user activity using session
  def track_user_activity
    session[:last_visit] = Time.current
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    
    # Show returning visitor message with custom flash
    if session[:visit_count] > 1 && session[:visit_count] % 5 == 0
      flash[:info] = "Welcome back! This is your #{session[:visit_count].ordinalize} visit."
    end
  end
  
  def last_visit
    session[:last_visit]
  end
  
  def current_cart
    cart_items = {}
    
    if session[:cart].present?
      session[:cart].each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product
        
        cart_items[product] = quantity.to_i
      end
    end
    
    cart_items
  end
  
  def cart_count
    current_cart.values.sum
  end
  
  def cart_total
    current_cart.sum { |product, quantity| product.on_sale? ? product.sale_price * quantity : product.price * quantity }
  end
end
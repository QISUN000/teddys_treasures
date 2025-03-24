class ApplicationController < ActionController::Base
  before_action :set_categories
  helper_method :current_cart, :cart_count, :cart_total
  
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
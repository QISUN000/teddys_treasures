class CartsController < ApplicationController
  def show
    @cart_items = {}
    products = Product.where(id: current_cart.keys)
    
    products.each do |product|
      @cart_items[product] = current_cart[product.id.to_s]
    end
    
    current_cart.keys.each do |product_id|
      unless products.exists?(id: product_id)
        current_cart.delete(product_id)
        session[:cart] = current_cart
      end
    end
    
    # Make session data available to view
    @visit_count = session[:visit_count]
    @last_visit = session[:last_visit]
    
    # Use a custom flash message if cart has items
    if current_cart.any? && !flash[:notice] && !flash[:info] && !flash[:error]
      flash.now[:warning] = "You have items waiting in your cart. Proceed to checkout?"
    end
  end

  def add_item
    product = Product.find_by(id: params[:product_id])
    if product
      current_cart[product.id.to_s] = current_cart[product.id.to_s].to_i + params[:quantity].to_i
      session[:cart] = current_cart
      
      # Use custom flash type based on cart size
      if current_cart.size >= 3
        flash[:info] = "You have #{current_cart.size} items in your cart!"
      else
        flash[:notice] = 'Item added to cart.'
      end
    else
      flash[:error] = 'Product not found.'
    end
    
    # Store last added product in session
    session[:last_added_product] = product.id if product
    
    redirect_back fallback_location: products_path
  end

  def remove_item
    if current_cart.delete(params[:product_id].to_s)
      session[:cart] = current_cart
      notice = 'Item removed from cart.'
    else
      notice = 'Item not found in cart.'
    end
    
    redirect_back fallback_location: cart_path, notice: notice
  end

  def update_quantity
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    
    if current_cart.key?(product_id)
      if quantity > 0
        current_cart[product_id] = quantity
      else
        current_cart.delete(product_id)
      end
      session[:cart] = current_cart
      notice = 'Cart updated.'
    else
      notice = 'Product not found in cart.'
    end
    
    redirect_back fallback_location: cart_path, notice: notice
  end

  def destroy
    session[:cart] = {}
    redirect_to cart_path, notice: 'Cart cleared.'
  end

  private

  def current_cart
    session[:cart] ||= {}
  end
  
  helper_method :cart_count, :cart_total
  
  def cart_count
    current_cart.values.sum
  end
  
  def cart_total
    @cart_items.sum { |product, quantity| product.price * quantity }
  end
end
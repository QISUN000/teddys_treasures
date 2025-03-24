class CartsController < ApplicationController
  def show
    @cart_items = current_cart
  end

  def add_item
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i
    
    current_cart[product_id] = current_cart[product_id].to_i + quantity
    session[:cart] = current_cart
    
    redirect_back fallback_location: products_path, notice: 'Item added to cart.'
  end

  def remove_item
    product_id = params[:product_id].to_i
    current_cart.delete(product_id.to_s)
    session[:cart] = current_cart
    
    redirect_back fallback_location: cart_path, notice: 'Item removed from cart.'
  end

  def update_quantity
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i
    
    if quantity > 0
      current_cart[product_id.to_s] = quantity
    else
      current_cart.delete(product_id.to_s)
    end
    
    session[:cart] = current_cart
    redirect_back fallback_location: cart_path, notice: 'Cart updated.'
  end

  def destroy
    session[:cart] = {}
    redirect_to cart_path, notice: 'Cart cleared.'
  end

  private

  def current_cart
    session[:cart] ||= {}
  end
end
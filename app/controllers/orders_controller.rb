class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create, :payment, :process_payment, :confirmation, :guest_checkout]
  
  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end
  
  def show
    @order = if user_signed_in?
      current_user.orders.find_by(id: params[:id])
    else
      Order.find_by(id: params[:id])
    end
    
    unless @order
      redirect_to root_path, alert: 'Order not found'
      return
    end
  end
  
  def checkout
    @cart_items = current_cart
    
    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end
    
    @order = current_user.orders.build
    @addresses = current_user.addresses
    @provinces = Province.all
    @address = @addresses.first || current_user.addresses.build
  end
  
  def create
    @cart_items = current_cart
    
    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end
    
    # Handle address differently for guests vs logged in users
    province_id = params.dig(:address, :province_id)
    province = Province.find_by(id: province_id)
    
    if province.nil?
      redirect_to cart_path, alert: 'Invalid province selected.'
      return
    end
    
    subtotal = calculate_subtotal(@cart_items)
    
    # Create order with or without user
    @order = Order.new(
      user: current_user, # Will be nil for guests
      status: :pending,
      subtotal: subtotal,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate,
      email: params[:email]
    )
    
    # Calculate tax amounts
    @order.gst_amount = subtotal * @order.gst_rate / 100
    @order.pst_amount = subtotal * @order.pst_rate / 100
    @order.hst_amount = subtotal * @order.hst_rate / 100
    @order.total = subtotal + @order.gst_amount + @order.pst_amount + @order.hst_amount
    
    if @order.save
      # Create order items
      @cart_items.each do |product, quantity|
        @order.order_items.create(
          product: product,
          quantity: quantity,
          price_at_purchase: product.price
        )
      end
      
      # Clear the cart
      session[:cart] = {}
      
      # Check if we have a payment method ID
      if params[:payment_method_id].present?
        # Process payment
        service = StripeService.new(@order, payment_params)
        result = service.process_payment
        
        if result[:success]
          # Payment successful redirect
          redirect_to confirmation_order_path(@order), notice: 'Payment successful! Your order has been confirmed.'
        else
          # Payment failed
          Rails.logger.error("Payment failed: #{result[:error]}")
          redirect_to payment_order_path(@order), alert: "Payment failed: #{result[:error]}"
        end
      else
        # No payment method provided - redirect to payment page
        redirect_to payment_order_path(@order), notice: 'Order created. Please complete your payment.'
      end
    else
      # If save fails, redirect back to cart
      redirect_to cart_path, alert: 'There was a problem creating your order.'
    end
  end
  
  def guest_checkout
    @cart_items = current_cart
    
    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty.'
      return
    end
    
    @provinces = Province.all
  end
  
  def payment
    @order = Order.find(params[:id])
    
    # Only show payment form for pending orders
    unless @order.pending?
      redirect_to root_path, alert: 'This order has already been processed.'
      return
    end
    
    # Set up Stripe payment intent client-side
    @publishable_key = Rails.configuration.stripe[:publishable_key]
  end
  
  def process_payment
    @order = Order.find(params[:id])
    
    # Only process payment for pending orders
    unless @order.pending?
      redirect_to root_path, alert: 'This order has already been processed.'
      return
    end
    
    # Process payment through Stripe
    service = StripeService.new(@order, payment_params)
    result = service.process_payment
    
    if result[:success]
      # Payment successful redirect
      redirect_to confirmation_order_path(@order), notice: 'Payment successful! Your order has been confirmed.'
    else
      # Log error and redirect
      Rails.logger.error("Payment failed: #{result[:error]}")
      redirect_to payment_order_path(@order), alert: "Payment failed: #{result[:error]}"
    end
  end
  
  def confirmation
    @order = Order.find(params[:id])
    
    # Only allow viewing if paid
    unless @order.paid?
      redirect_to root_path, alert: 'This order has not been paid yet.'
    end
  end
  
  private
  
  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
  
  def calculate_subtotal(cart_items)
    cart_items.sum { |product, quantity| product.price * quantity }
  end
  
  def payment_params
    params.permit(:payment_method_id, :email)
  end
  
end
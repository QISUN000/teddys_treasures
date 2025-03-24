class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_checkout]
  
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end
  
  def show
    @order = current_user.orders.find(params[:id])
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
    
    # Get or create address
    if params[:address_id].present?
      address = current_user.addresses.find_by(id: params[:address_id])
    else
      address = current_user.addresses.build(address_params)
      unless address.save
        @order = current_user.orders.build
        @addresses = current_user.addresses
        @provinces = Province.all
        @address = address
        render :checkout and return
      end
    end
    
    province = address.province
    subtotal = calculate_subtotal(@cart_items)
    
    # Create order
    @order = current_user.orders.build(
      status: :pending,
      subtotal: subtotal,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate
    )
    
    # Calculate tax amounts
    @order.gst_amount = subtotal * @order.gst_rate / 100
    @order.pst_amount = subtotal * @order.pst_rate / 100
    @order.hst_amount = subtotal * @order.hst_rate / 100
    @order.total = subtotal + @order.gst_amount + @order.pst_amount + @order.hst_amount
    
    if @order.save
      @cart_items.each do |product, quantity|
        @order.order_items.create(
          product: product,
          quantity: quantity,
          price_at_purchase: product.price
        )
      end
      
      session[:cart] = {}
      
      @order.update(status: :paid)
      
      redirect_to order_path(@order), notice: 'Order placed successfully!'
    else
      @addresses = current_user.addresses
      @provinces = Province.all
      @address = address
      render :checkout
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
  
  private
  
  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
  
  def calculate_subtotal(cart_items)
    cart_items.sum { |product, quantity| product.price * quantity }
  end

  def process_payment
    @order = Order.find(params[:id])
    
    # Only process payment for pending orders
    unless @order.pending?
      redirect_to order_path(@order), alert: 'This order has already been processed.'
      return
    end
    
    # Process payment through Stripe
    service = StripeService.new(@order, payment_params)
    result = service.process_payment
    
    if result[:success]
      # Send confirmation email
      OrderMailer.with(order: @order).confirmation_email.deliver_later if @order.user
      
      redirect_to order_confirmation_path(@order), notice: 'Payment successful! Your order has been confirmed.'
    else
      # Log error and redirect
      Rails.logger.error("Payment failed: #{result[:error]}")
      redirect_to order_path(@order), alert: "Payment failed: #{result[:error]}"
    end
  end
  
  def confirmation
    @order = Order.find(params[:id])
  end
  
  private
  
  def payment_params
    params.permit(:payment_method_id, :email)
  end
end
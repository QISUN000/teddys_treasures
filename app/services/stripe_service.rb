class StripeService
  def initialize(order, params)
    @order = order
    @params = params
  end
  
  def create_payment_intent
    Stripe::PaymentIntent.create({
      amount: @order.total.to_i,
      currency: 'cad',
      description: "Order ##{@order.id} - Teddy's Treasures",
      payment_method: @params[:payment_method_id],
      confirmation_method: 'manual',
      confirm: true,
      automatic_payment_methods: {
        enabled: true,
        allow_redirects: 'never'
      },
      metadata: {
        order_id: @order.id,
        customer_email: @order.user&.email || @params[:email]
      }
    })
  end
  
  def process_payment
    begin
      payment_intent = create_payment_intent
      
      if payment_intent.status == 'succeeded'
        @order.update(
          status: :paid,
          payment_id: payment_intent.id,
          payment_status: payment_intent.status
        )
        
        return { success: true }
      else
        return { 
          success: false, 
          status: payment_intent.status,
          error: "Payment status: #{payment_intent.status}"
        }
      end
    rescue Stripe::CardError => e
      return { success: false, error: e.message }
    rescue Stripe::StripeError => e
      return { success: false, error: e.message }
    rescue => e
      return { success: false, error: "An unexpected error occurred: #{e.message}" }
    end
  end
end
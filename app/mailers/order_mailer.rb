class OrderMailer < ApplicationMailer
  def confirmation_email
    @order = params[:order]
    @user = @order.user
    
    mail(
      to: @user.email,
      subject: "Order Confirmation ##{@order.id} - Teddy's Treasures"
    )
  end
end
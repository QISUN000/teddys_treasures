
module OrdersHelper
  def order_status_badge(status)
    case status
    when 'pending'
      'bg-warning text-dark'
    when 'paid'
      'bg-info text-dark'
    when 'shipped'
      'bg-primary'
    when 'delivered'
      'bg-success'
    when 'cancelled'
      'bg-danger'
    else
      'bg-secondary'
    end
  end
end
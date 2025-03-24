class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  enum :status, { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }
  
  validates :subtotal, :total, presence: true, if: :persisted?
  
  def calculate_totals
    self.subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    
    # Calculate taxes
    self.gst_amount = subtotal * (gst_rate || 0) / 100
    self.pst_amount = subtotal * (pst_rate || 0) / 100
    self.hst_amount = subtotal * (hst_rate || 0) / 100
    
    self.total = subtotal + gst_amount + pst_amount + hst_amount
  end
end

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    [
      "id", 
      "order_id", 
      "product_id", 
      "quantity", 
      "price_at_purchase", 
      "created_at", 
      "updated_at"
    ]
  end
  
  # Define which associations are allowed for Ransack searches
  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end

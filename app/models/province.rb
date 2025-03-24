class Province < ApplicationRecord
  has_many :addresses
  
  validates :name, :code, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

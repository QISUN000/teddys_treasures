class Province < ApplicationRecord
  has_many :addresses
  
  validates :name, :code, presence: true, uniqueness: true
  validates :gst_rate, :pst_rate, :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Define which attributes are allowed to be searched in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["code", "created_at", "gst_rate", "hst_rate", "id", "name", "pst_rate", "updated_at"]
  end
  
  # Define which associations are allowed to be searched in ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    ["addresses"]
  end
end

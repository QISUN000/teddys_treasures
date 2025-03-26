class Product < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many_attached :images
  
  validates :name, :description, :price, presence: true
  validates :price, :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    # Safe attributes to search
    %w[name description price sale_price sku stock_quantity created_at updated_at on_sale]
  end

  def self.ransackable_associations(auth_object = nil)
    # Safe associations to search
    %w[categories]
  end

  # Enable searching by category name
  ransacker :category_name, formatter: proc { |value|
    category_ids = Category.where("name ILIKE ?", "%#{value}%").pluck(:id)
    product_ids = ProductCategory.where(category_id: category_ids).pluck(:product_id).uniq
    product_ids.presence || nil
  } do |parent|
    parent.table[:id]
  end
  
  def on_sale?
    sale_price.present? && sale_price < price
  end
end
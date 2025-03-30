class Page < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :content, presence: true
  
  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  
  # Make the URL friendly
  def to_param
    slug
  end
  
  # For Ransack search
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "slug", "title", "updated_at"]
  end
  
  # You might also need ransackable_associations if you use associations in search
  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  private
  
  # Generate a slug from the title if one isn't provided
  def generate_slug
    self.slug = title.parameterize
  end
end
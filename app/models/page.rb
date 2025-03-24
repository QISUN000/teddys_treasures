class Page < ApplicationRecord
  validates :title, :content, :slug, presence: true
  validates :slug, uniqueness: true
end

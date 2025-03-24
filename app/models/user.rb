class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true, if: :persisted?
end

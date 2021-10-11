class Product < ApplicationRecord
  belongs_to :category
  has_one :stock, dependent: :destroy
  has_one_attached :photo
  validates :photo, presence: true

  accepts_nested_attributes_for :stock, update_only: true
end

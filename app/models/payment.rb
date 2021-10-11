class Payment < ApplicationRecord
  belongs_to :user
  has_one :address, dependent: :destroy
  has_many :orders, dependent: :destroy
end

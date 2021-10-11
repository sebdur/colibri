class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  belongs_to :payment
end

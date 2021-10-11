class AddPaymentToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :payment, null: true, foreign_key: true
  end
end

class AddMpToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :merchant_order_id, :string
    add_column :payments, :external_reference, :string
  end
end

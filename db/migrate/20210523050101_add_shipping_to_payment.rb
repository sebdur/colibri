class AddShippingToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :shipping, :string
  end
end

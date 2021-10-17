class AddDiscountToCoupon < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons, :discount, :integer
    add_column :coupons, :free_shipping, :boolean
  end
end

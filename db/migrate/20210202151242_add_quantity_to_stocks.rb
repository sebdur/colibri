class AddQuantityToStocks < ActiveRecord::Migration[6.0]
  def change
  	add_column :stocks, :stock_quantity, :integer, default: 0
  end
end

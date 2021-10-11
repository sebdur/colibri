class RemoveCityFromAddress < ActiveRecord::Migration[6.1]
  def change
    remove_column :addresses, :city, :string
    remove_column :addresses, :country, :string
  end
end

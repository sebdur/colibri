class AddPhoneToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :phone, :string
  end
end

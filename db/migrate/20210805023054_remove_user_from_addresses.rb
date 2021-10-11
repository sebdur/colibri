class RemoveUserFromAddresses < ActiveRecord::Migration[6.1]
  def change
    remove_reference :addresses, :user, null: false, foreign_key: true
    add_reference :addresses, :payment, null: false, foreign_key: true    
  end
end

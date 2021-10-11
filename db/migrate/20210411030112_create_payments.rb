class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :amount
      t.string :token
      t.string :payment_method
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

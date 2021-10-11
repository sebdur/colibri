class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :street2
      t.string :city
      t.string :region
      t.string :commune
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

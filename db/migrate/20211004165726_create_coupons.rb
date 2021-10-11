class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :description
      t.boolean :enabled

      t.timestamps
    end
  end
end

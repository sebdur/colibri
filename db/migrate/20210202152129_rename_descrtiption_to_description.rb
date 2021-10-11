class RenameDescrtiptionToDescription < ActiveRecord::Migration[6.0]
  def change
  	rename_column :products, :descrtiption, :description
  end
end

class AddNoteToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :note, :string
  end
end

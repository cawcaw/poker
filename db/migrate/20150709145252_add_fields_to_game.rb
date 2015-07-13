class AddFieldsToGame < ActiveRecord::Migration
  def change
    add_column :games, :token, :string
    add_column :games, :size, :integer, default: 2
  end
end

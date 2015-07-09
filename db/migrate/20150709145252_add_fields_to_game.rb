class AddFieldsToGame < ActiveRecord::Migration
  def change
    add_column :games, :code, :integer, limit: 9999
    add_column :games, :size, :integer, limit: 10, default: 2
  end
end

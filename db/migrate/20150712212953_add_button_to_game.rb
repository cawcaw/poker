class AddButtonToGame < ActiveRecord::Migration
  def change
    add_column :games, :button, :integer, default: 0
  end
end

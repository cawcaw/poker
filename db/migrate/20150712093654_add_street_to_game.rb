class AddStreetToGame < ActiveRecord::Migration
  def change
    add_column :games, :street, :integer
  end
end

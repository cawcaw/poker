class AddCheckToHand < ActiveRecord::Migration
  def change
    add_column :hands, :check, :boolean, default: false
  end
end

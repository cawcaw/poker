class AddAiToHand < ActiveRecord::Migration
  def change
    add_column :hands, :ai, :boolean, default: false
  end
end

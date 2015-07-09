class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :deck_state
      t.integer :pot
      t.integer :bet
      t.boolean :live

      t.timestamps null: false
    end
  end
end

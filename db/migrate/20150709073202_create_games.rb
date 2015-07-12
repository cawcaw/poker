class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :deck_state, default: "d"*52
      t.integer :pot
      t.integer :bet
      t.boolean :live, default: true

      t.timestamps null: false
    end
  end
end

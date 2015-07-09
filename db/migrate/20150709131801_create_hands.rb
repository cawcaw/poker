class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.references :player, index: true, foreign_key: true
      t.references :game,   index: true, foreign_key: true
      t.integer :stack,     default: 0
      t.integer :bet,       default: 0

      t.timestamps null: false
    end
  end
end

class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string  :name
      t.integer :bankroll
      t.boolean :horse, default: true

      t.string  :token, null: false

      t.timestamps null: false
    end
  end
end

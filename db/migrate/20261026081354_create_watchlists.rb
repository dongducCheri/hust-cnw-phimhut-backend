class CreateWatchlists < ActiveRecord::Migration[8.1]
  def change
    create_table :watchlists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :status, default: 0, null: false # 0: plan_to_watch, 1: watching, 2: completed

      t.timestamps
    end
    add_index :watchlists, [:user_id, :movie_id], unique: true
    add_index :watchlists, [:user_id, :status]
  end
end

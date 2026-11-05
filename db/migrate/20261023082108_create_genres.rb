class CreateGenres < ActiveRecord::Migration[8.1]
  def change
    create_table :genres do |t|
      t.integer :tmdb_genre_id
      t.string :name, null: false
      t.string :slug

      t.timestamps
    end
    add_index :genres, :name, unique: true
    add_index :genres, :tmdb_genre_id, unique: true
    add_index :genres, :slug, unique: true
  end
end

class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :title, null: false
      t.string :original_title
      t.text :overview
      t.integer :movie_type, default: 0, null: false # 0: phim lẻ, 1: phim bộ
      t.integer :release_year
      t.string :country
      t.integer :duration # thời lượng phút
      t.float :vote_average, default: 0.0
      t.integer :vote_count, default: 0
      t.string :age_rating
      t.string :poster_url
      t.string :banner_url
      t.string :trailer_url
      t.string :video_url
      t.boolean :is_published, default: true, null: false

      t.timestamps
    end
  end
end

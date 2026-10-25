class CreateEpisodes < ActiveRecord::Migration[8.1]
  def change
    create_table :episodes do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :season_number, default: 1, null: false
      t.integer :episode_number, null: false
      t.string :title, null: false
      t.integer :duration
      t.string :video_url

      t.timestamps
    end
  end
end
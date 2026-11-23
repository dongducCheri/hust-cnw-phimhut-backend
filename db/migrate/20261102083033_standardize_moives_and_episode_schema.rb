class StandardizeMoivesAndEpisodeSchema < ActiveRecord::Migration[8.1]
  def change
    remove_column :movies, :video_url, :string 
  end
end

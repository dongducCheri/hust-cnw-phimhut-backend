class RenameVideoUrlToObjectKeyInEpisodes < ActiveRecord::Migration[8.1]
  def change
    rename_column :episodes, :video_url, :object_key
  end
end

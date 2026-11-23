class RemoveObjectKeyFromEpisodes < ActiveRecord::Migration[8.1]
  def change
    remove_column :episodes, :object_key, :string
  end
end

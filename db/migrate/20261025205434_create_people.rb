class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.integer :tmdb_person_id
      t.string :name, null: false
      t.string :profile_url
      t.integer :gender

      t.timestamps
    end
    
  end
end
class CreateMovieCredits < ActiveRecord::Migration[8.1]
  def change
    create_table :movie_credits do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.integer :credit_type, default: 0, null: false   # 0: cast, 1: crew
      t.string :job
      t.string :character_name    
      t.integer :order_index, default: 0
      
      t.timestamps
    end
  end
end

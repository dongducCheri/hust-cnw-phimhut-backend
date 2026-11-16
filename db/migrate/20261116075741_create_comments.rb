class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end
  end
end

class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :post, null: false, foreign_key: true
      t.string :likeUser
      
      t.timestamps
    end
  end
end

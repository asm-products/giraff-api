class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites, id: :uuid do |t|
      t.uuid :image_id, null: false
      t.uuid :user_id,  null: false

      t.index [:image_id, :user_id], unique: true
    end

    add_foreign_key :favorites, :images
    add_foreign_key :favorites, :users
  end
end

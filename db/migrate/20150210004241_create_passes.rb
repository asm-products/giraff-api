class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes, id: :uuid do |t|
      t.datetime :created_at, null: false
      t.uuid :image_id, null: false
      t.uuid :user_id,  null: false

      t.index [:image_id, :user_id], unique: true
    end

    add_foreign_key :passes, :images
    add_foreign_key :passes, :users
  end
end

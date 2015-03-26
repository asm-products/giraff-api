class CreateTwitterPosts < ActiveRecord::Migration
  def change
    create_table :twitter_posts do |t|
      t.string :rid

      t.timestamps null: false
    end
    add_index(:twitter_posts, :rid)
   end
end

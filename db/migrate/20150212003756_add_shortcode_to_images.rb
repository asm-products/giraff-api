class AddShortcodeToImages < ActiveRecord::Migration
  def change
    add_column :images, :shortcode, :string, null: false

    add_index :images, :shortcode, unique: true
  end
end

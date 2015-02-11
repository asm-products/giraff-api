class AddBytesToImages < ActiveRecord::Migration
  def change
    add_column :images, :bytes, :integer, null: false
  end
end

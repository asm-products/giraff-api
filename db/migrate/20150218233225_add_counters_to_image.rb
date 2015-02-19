class AddCountersToImage < ActiveRecord::Migration
  def change
    add_column :images, :favorite_counter, :integer, default: 0, null: false
    add_column :images, :pass_counter, :integer, default: 0, null: false
  end
end

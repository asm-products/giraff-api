class AddFlagForOffensiveContent < ActiveRecord::Migration
  def change
    add_column :images, :flagged, :integer, default: 0
  end
end

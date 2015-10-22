class AddAnonymousToUser < ActiveRecord::Migration
  def change
    add_column :users, :anonymous, :boolean, default: false
  end
end

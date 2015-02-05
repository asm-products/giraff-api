class AddStateToImage < ActiveRecord::Migration
  def change
    add_column :images, :state, :string, default: :new
  end
end

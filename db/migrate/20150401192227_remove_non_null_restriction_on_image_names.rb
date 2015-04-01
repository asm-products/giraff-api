class RemoveNonNullRestrictionOnImageNames < ActiveRecord::Migration
  def change
    change_column_null(:images, :name, true)
  end
end

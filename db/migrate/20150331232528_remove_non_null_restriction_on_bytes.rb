class RemoveNonNullRestrictionOnBytes < ActiveRecord::Migration
  def change
    change_column_null(:images, :bytes, true)
  end
end

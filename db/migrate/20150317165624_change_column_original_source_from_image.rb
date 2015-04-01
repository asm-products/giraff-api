class ChangeColumnOriginalSourceFromImage < ActiveRecord::Migration
  def change
    change_column_null(:images, :original_source, true)
  end
end

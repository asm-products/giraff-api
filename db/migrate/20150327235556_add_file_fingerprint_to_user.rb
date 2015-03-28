class AddFileFingerprintToUser < ActiveRecord::Migration
  def change
    add_column :images, :file_fingerprint, :string
  end
end

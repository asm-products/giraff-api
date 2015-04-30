class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uid, null: false
      t.string :type
      t.references :user

      t.timestamps null: false
    end
  end
end

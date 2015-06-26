class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uid, null: false
      t.string :kind
      t.references :user

      t.timestamps null: false
    end
  end
end

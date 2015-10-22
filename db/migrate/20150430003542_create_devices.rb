class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices, id: :uuid do |t|
      t.string :uid, null: false
      t.string :kind
      t.uuid :user_id

      t.timestamps null: false
    end
  end
end

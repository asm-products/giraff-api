class CreateSimpleUsers < ActiveRecord::Migration
  def up
    drop_table :users

    create_table :users, id: :uuid do |t|
      t.string :authentication_token, null: false
      t.string :email

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :authentication_token
  end
end

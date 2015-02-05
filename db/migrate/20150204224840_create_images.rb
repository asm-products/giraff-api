class CreateImages < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    create_table :images, id: :uuid do |t|
      t.datetime  :created_at,      null: false
      t.string    :name,            null: false
      t.string    :original_source, null: false
    end
  end
end

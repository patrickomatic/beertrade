class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.text :message, null: false
      t.datetime :seen_at
      t.timestamps null: false
    end
  end
end

class AddHashcodeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :hashcode, :text, index: true
    change_column :notifications, :hashcode, :text, null: false, index: true
  end
end

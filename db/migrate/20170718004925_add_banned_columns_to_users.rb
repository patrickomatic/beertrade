class AddBannedColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :banned_at, :datetime
    add_column :users, :ban_details, :text
  end
end

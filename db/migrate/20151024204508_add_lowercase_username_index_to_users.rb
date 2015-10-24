class AddLowercaseUsernameIndexToUsers < ActiveRecord::Migration
  def change
    def up
      execute "CREATE UNIQUE INDEX index_users_on_lower_username ON users (lower(username))"
    end

    def down
      execute "DROP INDEX index_users_on_lower_username"
    end
  end
end

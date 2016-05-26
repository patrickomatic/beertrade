class AddLowercaseUsernameIndexToUsers < ActiveRecord::Migration
  def up
    create_index_sql = 'CREATE UNIQUE INDEX index_users_on_lower_username ON users'
    create_index_sql +=
      if database_adapter == 'sqlite3'
        ' (username COLLATE NOCASE)'
      else
        ' (lower(username))'
      end
    execute create_index_sql
  end

  def down
    execute "DROP INDEX index_users_on_lower_username"
  end

  def database_adapter
    Rails.application.config.database_configuration[Rails.env]['adapter']
  end
end

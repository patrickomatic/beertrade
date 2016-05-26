class AddSearchIndexToTradeAgreement < ActiveRecord::Migration
  def up
    if database_adapter == 'postgresql' # GIN indexes not supported by sqlite3
      execute("CREATE INDEX index_trade_on_agreement ON trades USING gin(to_tsvector('english', 'agreement'))")
    end
  end

  def down
    if database_adapter == 'postgresql' # GIN indexes not supported by sqlite3
      remove_index :trades, name: :index_trade_on_agreement
    end
  end

  def database_adapter
    Rails.application.config.database_configuration[Rails.env]['adapter']
  end
end

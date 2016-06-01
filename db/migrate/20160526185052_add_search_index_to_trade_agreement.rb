class AddSearchIndexToTradeAgreement < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    execute "CREATE INDEX CONCURRENTLY index_trade_on_agreement ON trades USING gin(to_tsvector('english', agreement))"
  end

  def down
    remove_index :trades, name: :index_trade_on_agreement
  end
end

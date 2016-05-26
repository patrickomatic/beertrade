class AddSearchIndexToTradeAgreement < ActiveRecord::Migration
  def up
    execute("CREATE INDEX index_trade_on_agreement ON trades USING gin(to_tsvector('english', agreement))")
  end

  def down
    remove_index :trades, name: :index_trade_on_agreement
  end
end

class AddCompletedAtToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :completed_at, :datetime
  end
end

class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.text :agreement
      t.timestamps null: false
    end
  end
end

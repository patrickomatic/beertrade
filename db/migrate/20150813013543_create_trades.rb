class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.text :agreement
      t.datetime :accepted_at
      t.timestamps null: false
    end
  end
end

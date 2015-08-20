class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.foreign_key :requester
      t.foreign_key :requestee
      t.datetime :accepted_at
      t.timestamps null: false
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :username, null: false
      t.string :auth_uid, index: true
      t.integer :positive_feedback, default: 0
      t.integer :neutral_feedback, default: 0
      t.integer :negative_feedback, default: 0
      t.timestamps null: false
    end
  end
end

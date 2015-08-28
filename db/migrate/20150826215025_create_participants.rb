class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user, null: false, index: true
      t.references :trade, null: false, index: true
      t.text :shipping_info
      t.text :feedback
      t.boolean :feedback_positive, default: false
      t.boolean :feedback_neutral, default: false
      t.boolean :feedback_negative, default: false
      t.datetime :accepted_at
      t.timestamps null: false
    end
  end
end

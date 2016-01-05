class AddFeedbackCountColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :positive_feedback_count, :integer, null: false, default: 0
    add_column :users, :neutral_feedback_count, :integer, null: false, default: 0
    add_column :users, :negative_feedback_count, :integer, null: false, default: 0
  end
end

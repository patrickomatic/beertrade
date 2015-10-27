class DropReputationCountsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :positive_feedback
    remove_column :users, :neutral_feedback
    remove_column :users, :negative_feedback
  end
end

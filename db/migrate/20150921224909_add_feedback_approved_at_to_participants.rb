class AddFeedbackApprovedAtToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :feedback_approved_at, :datetime
  end
end

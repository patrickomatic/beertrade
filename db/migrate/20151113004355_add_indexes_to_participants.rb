class AddIndexesToParticipants < ActiveRecord::Migration
  def up
    execute "CREATE INDEX index_participants_on_feedback_idx ON participants (feedback, feedback_approved_at)"
    execute "CREATE INDEX index_participants_on_feedback_type_idx ON participants (feedback_type, feedback_approved_at)"
  end
  
  def down
    execute "DROP INDEX index_participants_on_feedback_idx"
    execute "DROP INDEX index_participants_on_feedback_type_idx"
  end
end

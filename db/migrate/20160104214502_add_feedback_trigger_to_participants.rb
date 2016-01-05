class AddFeedbackTriggerToParticipants < ActiveRecord::Migration
  def up
    execute <<-SQL_TRIGGER
      CREATE OR REPLACE FUNCTION update_feedback_count() RETURNS TRIGGER
      AS $$
        BEGIN
          IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
            IF (TG_OP = 'UPDATE' AND (OLD.feedback_approved_at IS NOT NULL AND OLD.feedback_type IS NULL)) THEN
              RETURN FALSE;
            END IF;

            -- We should only update if feedback_type and feedback_approved_at
            -- was never previously set and that both values are properly set
            -- on update.
            IF (NEW.feedback_approved_at IS NOT NULL AND NEW.feedback_type IS NOT NULL) THEN
              -- feedback_type: 0 = negative, 1 = neutral, 2 = positive
              CASE NEW.feedback_type
                WHEN 0 THEN
                  UPDATE users SET "negative_feedback_count" = "negative_feedback_count" + 1 WHERE id = NEW.user_id;
                WHEN 1 THEN
                  UPDATE users SET "neutral_feedback_count" = "neutral_feedback_count" + 1 WHERE id = NEW.user_id;
                WHEN 2 THEN
                  UPDATE users SET "positive_feedback_count" = "positive_feedback_count" + 1 WHERE id = NEW.user_id;
                ELSE
                  RAISE NOTICE 'feedback_type unknown';
              END CASE;
            END IF;
          END IF;

          RETURN NEW;
        END;
        $$ language plpgsql;

        DROP TRIGGER IF EXISTS update_feedback_count ON participants;

        CREATE TRIGGER update_feedback_count
          AFTER INSERT OR UPDATE ON participants
          FOR EACH ROW
          EXECUTE PROCEDURE update_feedback_count();
    SQL_TRIGGER
  end

  def down
    execute <<-SQL_TRIGGER
      DROP TRIGGER IF EXISTS update_feedback_count ON participants;
      DROP FUNCTION IF EXISTS update_feedback_count();
    SQL_TRIGGER
  end
end

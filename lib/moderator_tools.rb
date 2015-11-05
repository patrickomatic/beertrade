module ModeratorTools
  class << self
    def import_trades_for_user(user, users_string)
      Trade.transaction do 
        usernames_from_string(users_string).each do |username|
          trade = Trade.new(agreement: nil)
          trade.create_participants(user, username)
         
          participant = trade.participant(user)
          other_participant = participant.other_participant

          participant.update_attributes(feedback: "successful trade", feedback_type: "positive")
          other_participant.update_attributes(accepted_at: Time.now, feedback: "successful trade", feedback_type: "positive")
        end
      end
    end

    def merge_trades_from_user(from_user, to_user)
      # TODO handle the case where a user changes their username
    end


    private

      def usernames_from_string(string)
        string.split(/[\s+,]+/).map {|s| s.gsub(%r{^/u/}, '') }.map(&:downcase)
      end
  end
end

class BadTradeReportedJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Reddit.pm("/r/beertrade", "a bad trader has been reported", 
              "notifications/bad_trade_reported", 
              participant: Participant.find(participant_id))
  end
end

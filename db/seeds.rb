require 'csv'
require 'set'

CSV.foreach(Rails.root.join("db/seed_data.csv")) do |row|
  date = DateTime.strptime(row[2], '%m/%d/%Y')
  user = User.find_or_create_by(username: row[0].strip.downcase)

  trade = Trade.new(agreement: "Trade on #{row[2]}", created_at: date)
  trade.create_participants(user, row[1].strip.downcase)
 
  participant = trade.participant(user)
  other_participant = participant.other_participant

  feedback = (row[3] || "").strip
  feedback = "successful trade on #{row[2]}" if feedback == ""

  participant.update_attributes(feedback: "successful trade on #{row[2]}", feedback_type: "positive")
  other_participant.update_attributes(accepted_at: date, feedback: feedback, feedback_type: "positive")

  trade.update_attributes(completed_at: date)
end

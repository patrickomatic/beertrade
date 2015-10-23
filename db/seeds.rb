require 'csv'

CSV.foreach(Rails.root.join("db/seed_data.csv")) do |row|
  fail "disable notifications before running this!"
  date = DateTime.strptime(row[0], '%m/%d/%Y %H:%M:%S')
  user = User.find_or_create_by(username: row[1])

  trade = Trade.new(agreement: "Trade on #{date}", created_at: date)
  trade.create_participants(user, row[2])
  
  participant = trade.participant(user)
  other_participant = participant.other_participant

  feedback = (row[3] || "").strip
  feedback = "successful trade on #{date}" if feedback == ""

  participant.update_attributes(feedback: "successful trade on #{date}", feedback_type: :positive)
  other_participant.update_attributes(feedback: feedback, feedback_type: :positive)

  trade.update_attributes(completed_at: date)
end

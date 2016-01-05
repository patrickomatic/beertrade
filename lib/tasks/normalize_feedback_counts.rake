namespace :normalize_counts do
  task feedback: :environment  do
    count = User.count
    n = 0

    puts "Normalizing feedback count columns for #{count} accounts"

    User.find_each do |user|
      user.positive_feedback_count = user.participants.completed.with_positive_feedback.count
      user.neutral_feedback_count = user.participants.completed.with_neutral_feedback.count
      user.negative_feedback_count = user.participants.completed.with_negative_feedback.count

      if user.save
        n += 1
        puts "#{n} updated"
      end
    end
  end
end

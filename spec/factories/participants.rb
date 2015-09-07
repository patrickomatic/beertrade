FactoryGirl.define do
  factory :participant do
    user
    trade

    trait :accepted do
      accepted_at Time.now
    end

    trait :with_feedback do
      feedback "A+ great trader"
      feedback_positive true
      accepted_at Time.now
    end

    trait :with_negative_feedback do
      feedback "this trade sucked"
      feedback_negative true
      accepted_at Time.now
    end

    trait :with_neutral_feedback do
      feedback "it was netural"
      feedback_neutral true
      accepted_at Time.now
    end
  end
end

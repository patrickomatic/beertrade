FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "patrickomatic-#{n}"}

    trait :with_trades do
      transient do
        positive_trade_count 1
        neutral_trade_count 0
        negative_trade_count 0
      end

      after(:build) do |user, evaluator|
        evaluator.positive_trade_count.times do
          FactoryGirl.create(:participant, :with_feedback, user: user)
        end
      end

      after(:build) do |user, evaluator|
        evaluator.neutral_trade_count.times do
          FactoryGirl.create(:participant, :with_neutral_feedback, user: user)
        end
      end

      after(:build) do |user, evaluator|
        evaluator.negative_trade_count.times do
          FactoryGirl.create(:participant, :with_negative_feedback, user: user)
        end
      end

      # Picks up DB trigger that mutates *_feedback_count columns based on
      # participants data.
      after(:create) do |user|
        user.reload
      end
    end
  end
end

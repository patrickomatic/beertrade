FactoryGirl.define do
  factory :trade do
    agreement "yinlin for pliny"

    trait :completed do
      completed_at Time.now

      after(:build) do |trade|
        trade.participants << FactoryGirl.build(:participant, :with_feedback, trade: trade)
        trade.participants << FactoryGirl.build(:participant, :with_feedback, trade: trade)
      end
    end

    trait :accepted do
      after(:build) do |trade|
        trade.participants << FactoryGirl.build(:participant, :accepted, trade: trade)
        trade.participants << FactoryGirl.build(:participant, :accepted, trade: trade)
      end
    end

    trait :waiting_for_approval do
      after(:build) do |trade|
        trade.participants << FactoryGirl.build(:participant, trade: trade)
        trade.participants << FactoryGirl.build(:participant, :accepted, trade: trade)
      end
    end
  end
end

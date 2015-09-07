FactoryGirl.define do
  factory :trade do
    agreement "yinlin for pliny"

    trait :completed do
      after(:build) do |trade| 
        trade.participants << FactoryGirl.build(:participant, :with_feedback)
        trade.participants << FactoryGirl.build(:participant, :with_feedback)
      end
    end

    trait :accepted do
      after(:build) do |trade| 
        trade.participants << FactoryGirl.build(:participant, :accepted)
        trade.participants << FactoryGirl.build(:participant, :accepted)
      end
    end

    trait :waiting_for_approval do
      after(:build) do |trade| 
        trade.participants << FactoryGirl.build(:participant)
        trade.participants << FactoryGirl.build(:participant, :accepted)
      end
    end
  end
end

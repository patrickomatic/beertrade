FactoryGirl.define do
  factory :participant do
    user
    trade


    trait :accepted do
      accepted_at Time.now
    end

    trait :feedback_approved do
      feedback_approved_at Time.now
    end

    trait :with_feedback do
      feedback "A+ great trader"
      feedback_type :positive 
      accepted_at Time.now
      feedback_approved_at Time.now
    end

    trait :with_negative_feedback do
      feedback "this trade sucked"
      feedback_type :negative 
      accepted_at Time.now
      feedback_approved_at Time.now
    end

    trait :with_neutral_feedback do
      feedback "it was netural"
      feedback_type :neutral 
      accepted_at Time.now
      feedback_approved_at Time.now
    end

    trait :with_shipping_info do
      shipping_info "774397776602"
    end
  end
end

FactoryGirl.define do
  factory :notification do
    user
    trade
    message "beer stuff has happened"
    sequence(:hashcode) {|n| "deadbeef#{n}"}
  end
end

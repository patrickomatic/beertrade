FactoryGirl.define do
  factory :notification do
    user
    trade
    message "beer stuff has happened"
  end
end

FactoryBot.define do
  factory :order do
    association :user
    association :cart
  end
end

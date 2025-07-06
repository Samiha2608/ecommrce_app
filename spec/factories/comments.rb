FactoryBot.define do
  factory :comment do
    association :user
    association :product
    content { "this is my first comment" }
  end
end

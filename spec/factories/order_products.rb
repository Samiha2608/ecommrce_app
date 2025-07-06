FactoryBot.define do
  factory :order_product do
    association :order
    association :product
    quantity { 7 }
  end
end

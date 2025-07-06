FactoryBot.define do
  factory :coupon do
    code { 777777 }
    discount { 15 }
    active { true }
    cateogory { "Jewelry" }
  end
end

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    email        { Faker::Internet.email }
    password     { Faker::Internet.password }
    sequence(:phone_number) do |n|
      area   = rand(100..999)
      prefix = rand(100..999)
      line   = n.to_s.rjust(4, '0')[-4..]   # => a 4‑digit string
      "#{area}-#{prefix}-#{line}"
    end

    address      { Faker::Address.full_address }
  end
end

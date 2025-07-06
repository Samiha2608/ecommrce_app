FactoryBot.define do
  factory :product do
    association :coupon
    association :user
    product_name { "Clip" }
    description { "Clip for females" }
    price { 21 }
    serial_number { "777888" }
    category { "Jewelry" }
    stock { 3 }
        after(:build) do |product|
      file1 = Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/bracelet2.jpg"), "image/jpeg"
      )
      file2 = Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/bracelet3.jpg"), "image/jpeg"
      )

      product.images.attach([ file1, file2 ])
    end
  end
end

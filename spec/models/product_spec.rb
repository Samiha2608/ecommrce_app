require 'rails_helper'

RSpec.describe Product, type: :model do
  context "is valid with valid product fields" do
    let(:product) { create :product }
    it "is valid with valid fields" do
      expect(product).to be_valid
    end
    it "is valid if no serial_number is given bcz serial number is generated on his own using callback" do
      product= build(:product, serial_number: nil)
      expect(product).to be_valid
    end
  end
  context "is invalid with some missing fields" do
    it "is invalid with missing name" do
      product = build(:product, product_name: nil)
      expect(product).not_to be_valid
    end
    it "is invalid with missing description" do
      product = build(:product, description: nil)
      expect(product).not_to be_valid
    end
    it "is invalid with missing price" do
      product= build(:product, price: nil)
      expect(product).not_to be_valid
    end
    it "is invalid with missing category" do
    product= build(:product, category: nil)
    expect(product).not_to be_valid
    end
    it "is invalid with missing stock" do
    product= build(:product, stock: nil)
    expect(product).not_to be_valid
    end
  end
  context "is invalid with wrong data" do
    it "is invalid if description range is less than 5" do
      product=build(:product, description: "gg")
      expect(product).not_to be_valid
    end
    it "is invalid if price is not an integer" do
      product=build(:product, price: "ddd")
      expect(product).not_to be_valid
    end
    it "is invalid if category range would be greater than 15" do
      product= build(:product, category: "ssssssssssssssssssssssss")
      expect(product).not_to be_valid
    end
    it "is invalid if stock is not an integer" do
      product = build(:product, stock: "hgg")
      expect(product).not_to be_valid
    end
  end
  context "is valid with coupon" do
    it "is valid with coupon" do
      product = build(:product, coupon_id: 2)
      expect(product).to be_valid
    end
  end
end

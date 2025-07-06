require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context "is valid with valid fields" do
    let(:coupon) { create :coupon }
    it "is valid with valid fields" do
      expect(coupon).to be_valid
    end
  end
  context "is invalid some or more missing fields" do
    it "is invalid with missing code" do
      coupon = build(:coupon, code: nil)
      expect(coupon).not_to be_valid
    end
    it "is invalid with missing discount field" do
      coupon = build(:coupon, discount: nil)
      expect(coupon).not_to be_valid
    end
    it "is invalid with missing active field" do
      coupon = build(:coupon, active: nil)
      expect(coupon).not_to be_valid
    end
    it "is invalid with missing category field" do
      coupon = build(:coupon, cateogory: nil)
      expect(coupon).not_to be_valid
    end
  end
end
# create_table "coupons", force: :cascade do |t|
#     t.integer "code"
#     t.integer "discount"
#     t.boolean "active"
#     t.text "cateogory"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end

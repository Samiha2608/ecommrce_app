require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
 it { is_expected.to belong_to(:order) }
 it { is_expected.to belong_to :product }

 context "should have positive integer in quantity field" do
  let(:order_product) { create :order_product }
  it "is valid with valid quantity" do
    order_product = build(:order_product, quantity: 1)
    expect(order_product).to be_valid
  end
 end
end

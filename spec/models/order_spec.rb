require 'rails_helper'


RSpec.describe Order, type: :model do
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to belong_to(:cart) }

  it { is_expected.to have_many(:order_products).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:order_products) }
end

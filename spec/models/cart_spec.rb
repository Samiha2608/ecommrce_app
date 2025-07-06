require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_one(:order) }
end

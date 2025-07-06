require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /checkouts/success" do
    it "redirects to root with a success notice" do
      get success_checkouts_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /checkouts/cancel" do
    it "redirects to cart with a cancel alert" do
      get cancel_checkouts_path
      expect(response).to redirect_to(cart_path)
    end
  end
end

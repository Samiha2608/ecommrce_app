require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "renders the sign up form" do
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("devise/registrations/new")
    end
  end
 describe "POST /users" do
    let(:valid_params) { attributes_for(:user) }

    it "creates a user and redirects" do
      expect {
        post user_registration_path, params: { user: valid_params }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end
  end
end

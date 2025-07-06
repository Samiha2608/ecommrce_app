require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user) }
  let(:products) { create(:product, user: user) }
  describe "Get /products" do
    it "returns success for index" do
      get products_path
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /products/:id" do
    it "returns success for show" do
      get products_path
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /products/new" do
    it "returns success when user signed in" do
      sign_in user
      user.add_role(:buyer)
      get new_product_path
      expect(response).to have_http_status(:success)
    end

    it "redirects if user not signed in" do
      get new_product_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  describe "POST /products" do
    it "creates product with valid data" do
      sign_in user
      user.add_role(:seller)
      product_params = attributes_for(:product).except(:coupon, :user)
      file= fixture_file_upload(
        Rails.root.join("spec/fixtures/files/bracelet2.jpg"), "image/jpeg"
      )
      expect {
        post products_path,
        params: { product: product_params.merge(images: [ file ]) }
    }.to change(Product, :count).by(1)
    expect(response).to redirect_to(products_path)
    end
  end
  describe "PATCH /products/:id" do
    let(:user)    { create(:user) }
    let!(:product) { create(:product, user: user) }

    it "updates a product" do
      sign_in user
      user.add_role(:seller)

      patch product_path(product), params: {
        product: { product_name: "Updated Product" }
      }

      expect(response).to redirect_to(new_product_path)
      expect(product.reload.product_name).to eq("Updated Product")
    end
  end
  describe "DELETE /products/:id" do
    let(:user)    { create(:user) }
    let!(:product) { create(:product, user: user) }
    it "deletes a product" do
      sign_in user
      user.add_role(:seller)
      expect {
        delete product_path(product)
      }.to change(Product, :count).by(-1)

      expect(response).to redirect_to(products_path)
    end
  end
end

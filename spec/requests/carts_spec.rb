require "rails_helper"

RSpec.describe "Carts", type: :request do
  let(:user)    { create(:user) }
  let(:product) { create(:product, stock: 5) }

  describe "GET /cart" do
    it "loads successfully (guest or signed‑in)" do
      get cart_path
      expect(response).to have_http_status(:success)

      sign_in user
      get cart_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /products/:id/add_to_cart" do
    it "redirects back to the product page" do
      sign_in user
      post add_to_cart_product_path(product)
      expect(response).to redirect_to(product_path(product))
    end
  end

  describe "DELETE /cart/remove_item/:id" do
    it "removes the order_product and redirects to cart" do
      sign_in user
      post add_to_cart_product_path(product)             # create cart + item
      order_product = user.carts.last.order.order_products.last

      expect {
        delete remove_item_cart_path(order_product)
      }.to change(OrderProduct, :count).by(-1)

      expect(response).to redirect_to(cart_path)
    end
  end

  describe "PATCH /cart/update_quantity/:id" do
    it "changes quantity and redirects to cart" do
      sign_in user
      post add_to_cart_product_path(product)
      order_product = user.carts.last.order.order_products.last

      patch update_quantity_cart_path(order_product),
            params: { order_product: { quantity: 2 } }

      expect(response).to redirect_to(cart_path)
      expect(order_product.reload.quantity).to eq(2)
    end
  end
end

require 'rails_helper'

RSpec.describe "CommentsController", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before { sign_in user }

  describe "POST   /products/:product_id/comments" do
    it "creates a comment" do
      expect {
        post product_comments_path(product), params: { comment: { content: "Comment 1" } }}.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:success).or have_http_status(:redirect)
    end
  end
  describe "GET /products/:product_id/comments/:id/edit"
  it "loads the edit form" do
    comment= create(:comment, product: product, user: user)
    get edit_product_comment_path(product, comment)
    expect(response).to have_http_status(:success)
  end
  describe "PATCH /products/:product_id/comments/:id" do
    it "updates the comment" do
      comment = create(:comment, product: product, user: user)

      patch product_comment_path(product, comment), params: {
        comment: { content: "uploaded comment" }
      }

      expect(comment.reload.content).to eq("uploaded comment")
    end
  end
  describe "/products/:product_id/comments/:id" do
    it "deletes the comment" do
      comment = create(:comment, product: product, user: user)
      expect { delete product_comment_path(product, comment) }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:success) or have_http_status(:redirect_to)
    end
  end
end

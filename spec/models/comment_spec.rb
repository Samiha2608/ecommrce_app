require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "should be able to create valid content" do
    let(:comment) { create :comment }
    it "has valid content" do
      expect(comment).to be_valid
    end
  end
  context "Should be invalid if field is empty" do
    it "should fail due to empty content field" do
      comment = build(:comment, content: nil)
      expect(comment).not_to be_valid
    end
  end
end

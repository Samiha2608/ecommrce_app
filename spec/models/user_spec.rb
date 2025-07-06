require 'rails_helper'

RSpec.describe User, type: :model do
  context "when creating a user with all the required fields" do # context is an example group
    let(:user) { create :user } # lazy loading work only for under the block of context.
      it "is valid with default attributes" do
      expect(user).to be_valid
      end
  end
  context "when user is not valid with some missing fields" do
    it "is not valid with missing email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end
    it "is invalid with some or more empty fields" do
      user= build(:user, email: nil, first_name: nil, password: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with empty first_name" do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
    end
    it "is invalid with empty last_name" do
      user = build(:user, last_name: nil)
      expect(user).not_to be_valid
    end
    it "is invalid with empty address" do
      user = build(:user, address: nil)
      expect(user).not_to be_valid
    end
    it "is invalid with empty phone_number" do
      user = build(:user, phone_number: nil)
      expect(user).not_to be_valid
    end
  end
  context "when user has invalid fields" do
    it "has invalid phone_number" do
      user= build(:user, phone_number: "0312223333")
      expect(user).not_to be_valid
    end
    it "has invalid first name" do
      user = build(:user, first_name: "123")
      expect(user).not_to be_valid
    end
    it "has invalid last name" do
      user = build(:user, last_name: "123")
      expect(user).not_to be_valid
    end
    it "has invalid email" do
      user = build(:user, email: "123gmail.com")
      expect(user).not_to be_valid
    end
    it "has password shorter than 6 characters" do
      user = build(:user, password: "123")
      expect(user).not_to be_valid
    end
  end
  context "when the records should be unique" do
    it "cannot had duplicate email" do
      user1 = build(:user, email: "123@gmail.com")
      user2 = build(:user, email: "123@gmail.com")
      expect(user1).not_to eq(user2)
    end
    it "cannot had same phone number as other user" do
      user1= build(:user, phone_number: "032-222-7777")
      user2 = build(:user, phone_number: "032-222-7777")
      expect(user1).not_to eq(user2)
    end
  end
end

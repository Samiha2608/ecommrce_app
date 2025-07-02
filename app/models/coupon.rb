class Coupon < ApplicationRecord
  has_many :products
  validates :code, presence: true, format: { with: /\A\d{6}\z/, message: "must be a 6-digit number" }
end

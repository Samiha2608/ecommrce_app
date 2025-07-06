class Coupon < ApplicationRecord
  has_many :products
  validates :code, presence: true, format: { with: /\A\d{6}\z/, message: "must be a 6-digit number" }
  validates :discount, presence: true
  validates :active, presence: true
  validates :cateogory, presence: true
end

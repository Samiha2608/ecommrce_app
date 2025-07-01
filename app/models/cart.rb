class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_one :order, dependent: :destroy
end

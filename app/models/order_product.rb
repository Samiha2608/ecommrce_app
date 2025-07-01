class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def total
    product.price * quantity
  end
end

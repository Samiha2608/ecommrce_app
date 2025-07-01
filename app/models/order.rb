class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  def total
    order_products.to_a.sum { |order_products| order_products.total }
  end
end

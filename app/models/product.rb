class Product < ApplicationRecord
  include AlgoliaSearch
  belongs_to :user
  belongs_to :coupon, optional: true
  has_many :comments, dependent: :destroy
  has_many_attached :images
  has_many :order_products
  has_many :orders, through: :order_products

  validates :product_name, presence: true
  validates :description, length: { in: 5..50 }
  validates :price, numericality: { only_integer: true }
  validates :serial_number, uniqueness: true, length: { is: 6 }, presence: true
  validates :category, presence: true, length: { in: 1..15 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }


  before_validation :product_first_letter_capital
  before_validation :generate_serial_number, on: :create

  algoliasearch index_name: "Product" do
    attribute :id, :product_name, :description, :price, :category, :serial_number

    searchableAttributes %w[
      unordered(product_name)
      unordered(category)
      description
    ]

    customRanking [ "desc(stock)", "asc(price)" ]
    attributesForFaceting [ :category ]
  end

  private

  def product_first_letter_capital
    self.product_name = product_name.titleize if product_name.present?
  end
  def generate_serial_number
    loop do
      self.serial_number = SecureRandom.alphanumeric(6).upcase
      break unless Product.exists?(serial_number: serial_number)
    end
  end
end

class User < ApplicationRecord
  has_many :products
  has_many :comments
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar


  validates :full_name, presence: true, length: { in: 3..20, message: "must be between 3 and 20 characters long" }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A((\+92|0092|92|0)?3[0-9]{9})\z/, message: "must be a valid phone number" }
  validates :address, presence: true, uniqueness: true, length: { maximum: 500, message: "must be less than 500 characters long" }
  validates :avatar, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 6.megabytes }, if: -> { avatar.attached? }


  attr_accessor :first_name, :last_name

  before_validation :combine_names, if: :names_provided?
  before_validation :ensure_phone_no_range
  before_create :capitalize_name_first_letter
  after_create :assign_default_role


  def Buyer
    has_role?(:buyer)
  end

  def Seller
    has_role?(:seller)
  end


  def names_provided?
    first_name.present? && last_name.present?
  end

  def combine_names
    self.full_name = "#{first_name.strip} #{last_name.strip}"
  end

  protected

  def assign_default_role
    self.add_role(:buyer)
  end

  def ensure_phone_no_range
    if phone_number.present? && (phone_no < 10000000000 || phone_no > 99999999999)
      errors.add(:phone_no, "must be a 11-digit number")
      throw :abort
    end
  end
  def capitalize_name_first_letter
    self.full_name= full_name.titleize if full_name.present?
  end
end

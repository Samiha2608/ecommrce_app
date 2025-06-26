class AddCouponToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :coupon, null: false, foreign_key: true
  end
end

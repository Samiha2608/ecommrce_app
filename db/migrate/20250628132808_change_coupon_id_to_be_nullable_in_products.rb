class ChangeCouponIdToBeNullableInProducts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :products, :coupon_id, true
  end
end

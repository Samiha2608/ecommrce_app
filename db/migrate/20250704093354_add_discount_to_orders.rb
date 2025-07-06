class AddDiscountToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :discount, :integer
  end
end

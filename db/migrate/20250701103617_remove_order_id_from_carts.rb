class RemoveOrderIdFromCarts < ActiveRecord::Migration[7.2]
  def change
    remove_reference :carts, :order, null: false, foreign_key: true
  end
end

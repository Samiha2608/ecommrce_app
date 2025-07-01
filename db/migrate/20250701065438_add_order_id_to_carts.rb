class AddOrderIdToCarts < ActiveRecord::Migration[7.2]
  def change
    add_reference :carts, :order, null: false, foreign_key: true
  end
end

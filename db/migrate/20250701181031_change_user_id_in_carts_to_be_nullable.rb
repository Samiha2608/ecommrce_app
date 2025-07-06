class ChangeUserIdInCartsToBeNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :carts, :user_id, true
  end
end

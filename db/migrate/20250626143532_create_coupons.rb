class CreateCoupons < ActiveRecord::Migration[7.2]
  def change
    create_table :coupons do |t|
      t.integer :code
      t.integer :discount
      t.boolean :active
      t.text :cateogory

      t.timestamps
    end
  end
end

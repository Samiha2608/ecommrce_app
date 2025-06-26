class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :product_name
      t.text :description
      t.integer :price
      t.string :serial_number
      t.text :category
      t.references :seller, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateProductImages < ActiveRecord::Migration[5.2]
  def change
    create_table :product_images do |t|
      t.integer  :product_id
      t.integer  :weight, default: 0
      t.string   :image
      t.timestamps
    end

    add_index :product_images, :product_id
    add_index :product_images, [:product_id, :weight]
  end
end

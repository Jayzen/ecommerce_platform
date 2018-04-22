class ProductImage < ApplicationRecord
  belongs_to :product
  mount_uploader :image, ProductImageUploader
end

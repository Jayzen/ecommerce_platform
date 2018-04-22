class ProductImagesController < ApplicationController
  before_action :find_product

  def index
    @product_images = @product.product_images
  end

  def create
    if params[:images].nil?
      @product.errors.add(:image, "不能上传空照片!")
      @product_images = @product.product_images
      render 'index'
    else
      params[:images].each do |image|
        @product.product_images << ProductImage.new(image: image)
      end
      flash[:success] = "照片提交成功!"
      redirect_to product_product_images_path(@product)
    end
  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    if @product_image.destroy
      flash[:success] = "删除照片成功!"
    else
      flash[:danger] = "删除照片失败!"
    end

    redirect_to product_product_images_path(@product)
  end

  def update
    @product_image = @product.product_images.find(params[:id])
    @product_image.weight = params[:weight]
    if @product_image.save
      flash[:success] = "权重值修改成功!"
    else
      flash[:danger] = "权重值修改失败!"
    end
    redirect_to product_product_images_path(@product)
  end

  private
    def find_product
      @product = Product.find params[:product_id]
    end
end

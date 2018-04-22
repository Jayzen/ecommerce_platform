class ProductsController < ApplicationController
  before_action :find_product, only: [:edit, :update, :destroy, :show]
  before_action :logged_in_user, except: [:show]
  before_action :admin_user, except: [:show]
  before_action :fetch_home_data, only: [:show]

  def index
    @products = Product.page(params[:page] || 1).order("id desc")
  end
  
  def show
  end

  def new
    @product = Product.new
    @root_categories = Category.roots
  end

  def create
    @product = Product.new(params.require(:product).permit!)
    @root_categories = Category.roots

    if @product.save
      flash[:success] = "创建成功!"
      redirect_to products_path
    else
      render action: :new
    end
  end

  def edit
    @root_categories = Category.roots
    render action: :new
  end

  def update
    @product.attributes = params.require(:product).permit!
    @root_categories = Category.roots
    if @product.save
      flash[:success] = "修改成功!"
      redirect_to products_path
    else
      render action: :new
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = "删除成功!"
      redirect_to products_path
    else
      flash[:danger] = "删除失败!"
      redirect_to :back
    end
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end 
end

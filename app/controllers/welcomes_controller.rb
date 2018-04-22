class WelcomesController < ApplicationController
  def index
    fetch_home_data

    @products = Product.onshelf.page(params[:page] || 1).per(12)
      .order("id desc").includes(:main_product_image) 
  end
end

class OrdersController < ApplicationController

  before_action :logged_in_user

  def new
    fetch_home_data
    @shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid)
      .order("id desc").includes([:product => [:main_product_image]])
    @addresses = current_user.addresses
    @address = Address.new
  end

  def create
    shopping_carts = ShoppingCart.by_user_uuid(current_user.uuid).includes(:product)
    if shopping_carts.blank?
      redirect_to shopping_carts_path
      return
    end

    address = current_user.addresses.find(params[:address_id])
    orders = Order.create_order_from_shopping_carts!(current_user, address, shopping_carts)

    redirect_to payments_path
  end

end

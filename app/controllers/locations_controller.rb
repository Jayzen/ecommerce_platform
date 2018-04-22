class LocationsController < ApplicationController
  before_action :logged_in_user
  before_action :find_location, only: [:edit, :update, :show, :destroy, :set_default_address]

  def show
  end

  def edit
    render action: :new
  end

  def update
    if @location.update(location_params)
      flash[:success] = "地址更新成功"
      redirect_to location_path(@location)
    else
      render 'edit'
    end
  end

  def index
    @locations = current_user.addresses
  end

  def new
    @location = current_user.addresses.build
  end

  def create
    @location = current_user.addresses.build(location_params)
    if @location.save
      flash[:success] = "地址创建成功"
      redirect_to locations_path
    else
      render 'new'
    end
  end

  def destroy
    @location.destroy
    flash[:success] = "地址删除成功"
    redirect_to locations_path
  end

  def set_default_address
    @location.set_as_default = 1
    @location.save
    @locations = current_user.reload.addresses
    flash[:success] = "默认地址设置成功"
    redirect_to locations_path
  end

  private
    def find_location
      @location = current_user.addresses.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:contact_name, :cellphone, :address, :zipcode)
    end
end

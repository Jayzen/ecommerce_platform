class AddressesController < ApplicationController
  before_action :logged_in_user
  before_action :find_address, only: [:edit, :update, :destroy, :set_default_address]

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      @addresses = current_user.reload.addresses
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end


  def update
    @address.attributes = address_params
    if @address.save
      @addresses = current_user.reload.addresses
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @address.destroy
    @addresses = current_user.reload.addresses
    respond_to do |format|
      format.js
    end
  end

  def set_default_address
    @address.set_as_default = 1
    @address.save
    @addresses = current_user.reload.addresses
    respond_to do |format|
      format.js
    end
  end

  private
  def address_params
    params.require(:address).permit(:contact_name, :cellphone, :address,
      :zipcode, :set_as_default)
  end

  def find_address
    @address = current_user.addresses.find(params[:id])
  end
end

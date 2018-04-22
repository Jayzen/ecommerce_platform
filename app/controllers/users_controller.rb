class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update, :edit, :destroy, 
                                   :authorize, :unauthorize,
                                   :avatar_new, :avatar_create, :avatar_update]
  before_action :logged_in_user, only: [:edit, :update, :destroy, :show, :index,
                                        :avatar_create, :avatar_update, :avatar_new]
  before_action :correct_user, only: [:edit, :update,
                                   :avatar_create, :avatar_update, :avatar_new]
  before_action :admin_user, only: [:destroy, :index, :destroy]
  before_action :superadmin_user, only: [:authorize, :unauthorize, :destroy]

  def show
    if request.path != user_path(@user)
      redirect_to @user, :status => :moved_permanently
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.uuid = session[:user_uuid]
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:danger] = "查看邮箱，进行激活"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @user.slug = nil
    if @user.update_attributes(user_params)
      flash[:success] = "用户更新成功!"
      redirect_to edit_user_path(@user)
    else
      render 'new'
    end
  end

  def index
    @users = User.order("created_at desc").page(params[:page])
  end

  def destroy
    @user.destroy
    flash[:success] = "用户已经被删除!"
    redirect_to users_path
  end

  def authorize
    @user.toggle!(:admin)

    respond_to do |format|
      format.js
    end
  end

  def forbidden
    @user = User.find(params[:user_id])
    @user.toggle!(:forbidden)

    respond_to do |format|
      format.js
    end
  end

  def unforbidden
    @user = User.find(params[:user_id])
    @user.toggle!(:forbidden)

    respond_to do |format|
      format.js
    end
  end

  def unauthorize
    @user.toggle!(:admin)

    respond_to do |format|
      format.js
    end 
  end
  
  private
    def find_user
      @user = User.friendly.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:portrait, :gender, :description)
    end
end

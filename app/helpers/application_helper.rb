module ApplicationHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "用户需要进行登录!"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.friendly.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def superadmin_user
    redirect_to(root_url) unless current_user.superadmin?
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def show_add_to_cart product, options = {}
    html_class = "btn btn-danger add-to-cart-btn"
    html_class += " #{options[:html_class]}" unless options[:html_class].blank?

    link_to "<i class='fa fa-spinner'></i> 加入购物车".html_safe, shopping_carts_path, class: html_class, 'data-product-id': product.id
  end
end

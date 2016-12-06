class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        user.is_admin? ? redirect_to(admin_root_url) : redirect_back_or(user)
      else
        flash[:warning] = t "users.account_activation.not_activate"
        redirect_to root_url
      end
    else
      flash[:danger] = t".danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

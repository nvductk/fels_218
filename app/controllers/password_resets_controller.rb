class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user,
    :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.new.sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.new.not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password_resets.errors")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "password_resets.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def load_user
    @user.skip_verify_current_password = true
    @user = User.find_by email: params[:email]
    render_404 unless @user
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "users.password_reset.check_expiration"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end

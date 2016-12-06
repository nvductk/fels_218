class Admin::UsersController < ApplicationController
  before_action :verify_login, :verify_admin
  before_action :load_user, except: [:index, :show, :create]
  layout "admin"

  def index
    @users = User.search(params[:q])
      .paginate page: params[:page], per_page: Settings.admin_page
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t".profile"
      redirect_to admin_root_url
    else
      flash[:danger] = t".update_fail"
      redirect_to admin_root_url
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t".success"
      redirect_to admin_root_url
    else
      flash[:danger] = t".danger"
      redirect_to admin_root_url
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :current_password, :avatar, :is_admin
  end
end

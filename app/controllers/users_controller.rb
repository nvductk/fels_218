class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]

  def show
    load_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t".success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    load_user
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update_attributes user_params
      flash[:success] = t".profile"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :current_password, :avatar
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end

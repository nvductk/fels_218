class UsersController < ApplicationController
  before_action :verify_login, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]

  def show
    @lessons = @user.lessons.order_by_creation_time
      .paginate page: params[:page], per_page: Settings.page
    render :show_lesson_results
  end

  def index
    @users = User.search(params[:q])
      .paginate page: params[:page], per_page: Settings.page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.create.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
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
end

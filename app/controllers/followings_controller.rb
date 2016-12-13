class FollowingsController < ApplicationController
  before_action :verify_login, :load_user

  def show
    @following = @user.following
    @users = @following.paginate page: params[:page],
      per_page: Settings.page
  end
end

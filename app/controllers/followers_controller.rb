class FollowersController < ApplicationController
  before_action :verify_login, :load_user

  def show
    @followers = @user.followers
    @users = @followers.paginate page: params[:page],
      per_page: Settings.page
  end
end

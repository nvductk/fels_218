class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def verify_login
    unless logged_in?
      store_location
      flash[:danger] = t"users.show.please_log_in"
      redirect_to login_url
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end

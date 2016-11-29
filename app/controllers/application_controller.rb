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

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t".please_log_in"
      redirect_to login_url
    end
  end
end

class CategoriesController < ApplicationController
  before_action :verify_login

  def index
    @categories = Category.search_by_name(params[:q]).paginate page: params[:page],
      per_page: Settings.admin_page
  end
end

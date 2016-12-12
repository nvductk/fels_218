class Admin::CategoriesController < ApplicationController
  before_action :verify_login, :verify_admin
  before_action :load_category, except: [:index, :create]
  layout "admin"

  def index
    @categories = Category.search_by_name(params[:q]).order_by_creation_time
      .paginate page: params[:page], per_page: Settings.admin_page
    @category = Category.new
  end

  def show
    @words = @category.words.search_by_content(params[:q]).order_by_creation_time
      .includes(:answers).paginate page: params[:page], per_page: Settings.admin_page
    @word = Word.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      render partial: "category", locals:{category: @category}
    else
      render partial: "shared/error_messages", locals: {object: @category}
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "admin.categories.update.success"
      render partial: "category", locals:{category: @category}
    else
      flash[:danger] = t "admin.categories.update.danger"
      render partial: "shared/error_messages", locals: {object: @category}
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.categories.delete.success"
    else
      flash[:danger] = t "admin.categories.delete.danger"
    end
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    render_404 if @category.nil?
  end

  def category_params
    params.require(:category).permit :name
  end
end

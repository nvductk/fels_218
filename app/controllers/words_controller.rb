class WordsController < ApplicationController
  before_action :verify_login, :load_all_categories, only: [:index]

  def index
    params[:search] ||= ""
    params[:status] ||= Settings.word.filters.first
    @words = Word.in_category(params[:category_id])
      .send(params[:status], current_user.id, params[:search])
      .paginate page: params[:page], per_page: Settings.page
  end
end

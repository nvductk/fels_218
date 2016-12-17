class Admin::CsvController < ApplicationController
  before_action :verify_login, :verify_admin

  def index
    @words = Word.order :created_at
    respond_to do |format|
      format.html
      format.csv {send_data @words.export(col_sep: "\t"), filename: "words-#{Date.today}.csv"}
    end
  end

  def create
    Word.import params[:file]
    redirect_to :back, notice: I18n.t(".word_imported")
  end
end

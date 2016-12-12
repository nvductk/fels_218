class Admin::WordsController < ApplicationController
  before_action :verify_login, :verify_admin
  before_action :load_word, only: [:destroy, :update]
  layout "admin"

  def create
    @word = Word.create word_params
    if @word.save
      render partial: "word", locals:{word: @word}
    else
      render partial: "shared/error_messages", locals: {object: @word}
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      respond_to do |format|
        format.html {render partial: "word", locals:{word: @word}}
      end
    else
      respond_to do |format|
        format.html {render partial: "shared/error_messages", locals: {object: @word}}
      end
    end
  end

  def destroy
    if @word.destroy
      flash[:success] = t "admin.words.word.destroy.success"
    else
      flash[:danger] = t "admin.words.word.destroy.danger"
    end
  end

  private
  def load_word
    @word = Word.find_by id: params[:id]
    render_404 if @word.nil?
  end

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end
end

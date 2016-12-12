class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy, inverse_of: :word
  has_many :results, dependent: :destroy

  validates :content, presence: true, length: {maximum: 50},
    uniqueness: {case_sensitive: false}
  validates :category_id, presence: true
  validate :check_answers

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:content].blank?}

  private
  def check_answers
    actual_size = self.answers.select{|answer| answer.is_correct}.size
    if actual_size == 0
      errors.add I18n.t("answer"), I18n.t("zero")
    end
    if actual_size > 1
      errors.add I18n.t("answer"), I18n.t("more_than_1")
    end
    if answers.length > answers.group_by { |a| a[:content] }.length
      self.errors.add :answers, I18n.t("duplicated")
    end
  end
end

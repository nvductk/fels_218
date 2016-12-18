class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy, inverse_of: :word
  has_many :results, dependent: :destroy
  scope :all_words, -> user_id, search {where "content LIKE ?", "%#{search}%"}
  scope :learnt_words, -> user_id, search {where LEARNT_QUERY, user_id: user_id,
    search: "%#{search}%"}
  scope :not_yet_learnt, -> user_id, search {where NOT_YET_QUERY, user_id: user_id,
    search: "%#{search}%"}
  scope :in_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

  LEARNT_QUERY = "content like :search and id in (select word_id
    FROM results as r INNER JOIN lessons as l
    ON r.lesson_id = l.id WHERE l.user_id = :user_id)"

  NOT_YET_QUERY = "content like :search and id not in (select word_id
    FROM results as r INNER JOIN lessons as l
    ON r.lesson_id = l.id WHERE l.user_id = :user_id)"

  validates :content, presence: true, length: {maximum: 50},
    uniqueness: {case_sensitive: false}
  validates :category_id, presence: true
  validate :check_answers

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:content].blank?}

  class << self
    def import file
      CSV.foreach file.path, headers: true, col_sep: "|",
        header_converters: :symbol do |row|
        row = row.to_hash
        answers_attributes = []
        row[:answers].split(";").each do |answer|
          answer_hash = Hash.new
          arr_answer = answer.split ","
          answer_hash[:content] = arr_answer[0]
          answer_hash[:is_correct] = arr_answer[1]
          answers_attributes.push answer_hash
        end
        row[:answers_attributes] = answers_attributes
        row.delete :answers
        Word.create! row
      end
    end

    def list_word
      self.order(created_at: :ASC).includes :category
    end
  end

  def self.export options = []
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |order|
        csv << order.attributes.values_at(*column_names)
      end
    end
  end

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

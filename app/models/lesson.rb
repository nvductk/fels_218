class Lesson < ApplicationRecord
  include CreateActivity
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy

  validates :user, presence: true
  validates :category, presence: true

  before_create :word_for_lesson
  after_create :start_lesson
  before_update :finish_lesson
  accepts_nested_attributes_for :results,
    reject_if: proc{|attributes| attributes[:answer_id].blank?}

  def number_correct_answer
    self.results.correct.count
  end

  private
  def word_for_lesson
    self.category.words.order("RANDOM()").limit(Settings.words).each do |word|
      self.results.build word_id: word.id
    end
  end

  def start_lesson
    create_activity :start_lesson, id, user_id
  end

  def finish_lesson
    create_activity :finish_lesson, id, user_id
  end
end

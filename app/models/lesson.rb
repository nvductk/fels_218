class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy

  validates :user, presence: true
  validates :category, presence: true

  before_create :word_for_lesson

  accepts_nested_attributes_for :results,
    reject_if: proc{|attributes| attributes["content"].blank?}

  private
  def word_for_lesson
    self.category.words.order("RANDOM()").limit(Settings.words).each do |word|
      self.results.build word_id: word.id
    end
  end
end

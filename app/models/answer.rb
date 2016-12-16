class Answer < ApplicationRecord
  belongs_to :word
  has_many :results, dependent: :destroy
  scope :correct, ->{where is_correct: true}

  validates :content, presence: true, length: {maximum: 50}
end

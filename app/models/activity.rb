class Activity < ApplicationRecord
  include ActionView::Helpers::DateHelper
  belongs_to :user

  enum action_type: [:follow, :unfollow, :start_lesson, :finish_lesson]
  validates :target_id, presence: true
  validates :user_id, presence: true

end

class Relationship < ApplicationRecord
  include CreateActivity
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_save :create_follow_activity
  before_destroy :create_unfollow_activity

  private
  def create_follow_activity
    create_activity :follow, followed_id, follower_id
  end

  def create_unfollow_activity
    create_activity :unfollow, followed_id, follower_id
  end
end

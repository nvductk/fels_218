class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :search_by_name, -> name {where "name LIKE ?", "%#{name}%"}
  scope :search_by_content, -> content {where "content LIKE ?", "%#{content}%"}
  scope :order_by_creation_time, -> {order created_at: :desc}
  scope :order_by_updated_time, -> {order updated_at: :desc}
end

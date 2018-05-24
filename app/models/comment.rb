class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  # belongs_to :website
  scope :latest, -> { order(created_at: :desc) }

  self.per_page = 5
end

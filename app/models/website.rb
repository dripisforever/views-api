class Website < ApplicationRecord
	has_many :urls
	has_many :likes, dependent: :destroy
	has_many :likers, through: :likes, source: :user
  has_many :comments, dependent: :destroy
	has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

	include SearchableWebsite

	scope :get_page, -> (page, per_page = 5) {
    includes(:title, :body, :urls).order(created_at: :desc).paginate(page: page, per_page: per_page)
  }
end

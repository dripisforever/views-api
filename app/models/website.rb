class Website < ApplicationRecord
	has_many :urls
	has_many :likes, dependent: :destroy
	has_many :likers, through: :likes, source: :user
  has_many :comments, dependent: :destroy
	has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
	
	include SearchableWebsite
end

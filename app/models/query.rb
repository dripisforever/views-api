require 'typhoeus/adapters/faraday'
class Query < ApplicationRecord
  # USERNAME_REGEX = /\A[a-zA-Z0-9_-]{3,30}\z/
  before_save {self.name = name.downcase}
  include SearchableQuery
  belongs_to :user

  # validates :name, presence: true, uniqueness: { case_sensitive: false },
                      # format: { with: USERNAME_REGEX, message: "should be one word" }

  # has_many :clicks
  # has_many :counts
  # has_many :likes, dependent: :destroy
  # has_many :clicks, dependent: :destroy
  # has_many :visitors, dependent: :destroy
end

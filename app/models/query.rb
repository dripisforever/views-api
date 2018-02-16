class Query < ApplicationRecord
  before_save {self.name = name.downcase}
  include SearchableQuery
  belongs_to :user
  # has_many :likes
  # has_many :clicks
  # has_many :visitors
end

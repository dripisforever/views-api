class Query < ApplicationRecord
  before_save {self.name = name.downcase}
  include SearchableQuery
  belongs_to :user
  # has_many :likes, dependent: :destroy
  # has_many :clicks, dependent: :destroy
  # has_many :visitors, dependent: :destroy
end

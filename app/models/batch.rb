class Batch < ApplicationRecord
  has_many :sites, :dependent => :destroy
  # attr_accessor :status, :keywords, :started_time, :finish_time
end

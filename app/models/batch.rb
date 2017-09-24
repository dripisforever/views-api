class Batch < ApplicationRecord
  has_many :sites, :dependent => :destroy
end

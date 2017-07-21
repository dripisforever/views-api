class Website < ApplicationRecord
	# has_many :urls
	# include Elasticsearch::Model
	include SearchableWebsite
end

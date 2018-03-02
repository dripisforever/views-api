module ModelQuery
	def self.multi_match(keyword)
		{
			multi_match: {
	      query: term,
	      fields: ['username^10', 'email', 'first_name', 'last_name']
      }
		}
	end

	def self.exact(keyword)
		{
			term: {
        username: term
      }
		}
	end

	module Highlight
		def self.build(keyword)
			{
        tags_schema: 'styled',
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          username:  { number_of_fragments: 5, fragment_size: 25, fragmenter: 'simple'},
          title:     { fragmenter: 'simple', phrase_limit: 100, number_of_fragments: 5}
        }
      }
		end
	end
end
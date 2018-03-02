module SearchableUser
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # Sync up Elasticsearch with PostgreSQL.
    after_commit :index_document, on: [:create, :update]
    after_commit :delete_document, on: [:destroy]

    settings INDEX_OPTIONS do
      mappings dynamic: 'false' do
        indexes :username, analyzer: 'autocomplete'
        indexes :email
        indexes :avatar_url
        # indexes :slug
      end
    end

    def self.search(term)
      # __elasticsearch__.search(query:     ModelQuery.build(keyword),
      #                          aggs:      ModelQuery::Aggregate.build,
      #                          highlight: ModelQuery::Highlight.build(term))

      __elasticsearch__.search(

          # Multi Match Request

          # query: {
          #   multi_match: {
          #     query: term,
          #     fields: ['username^10', 'email', 'first_name', 'last_name']
          #   }
          # },

          query: {
            term: {
              username: term
            }
          },

          highlight: {
              tags_schema: 'styled',
              pre_tags: ['<em>'],
              post_tags: ['</em>'],
              fields: {
                username:  { number_of_fragments: 5, fragment_size: 25, fragmenter: 'simple'},
                title:     { fragmenter: 'simple', phrase_limit: 100, number_of_fragments: 5}
              }
          }

      )
    end
  end


  def as_indexed_json(options ={})
    self.as_json({
      methods: [:avatar_url],
      only: [:username, :email, :avatar_url]
    })
  end

  def index_document
    ElasticsearchIndexWorker.perform_async('index', 'User', self.id)
    self.posts.find_each do |post|
      ElasticsearchIndexWorker.perform_async('index', 'Post', post.id) if post.created_at?
    end
  end

  def delete_document
    ElasticsearchIndexWorker.perform_async('delete', 'User', self.id)
    self.posts.find_each do |post|
      ElasticsearchIndexWorker.perform_async('delete', 'Post', post.id) if post.created_at?
    end
  end

  INDEX_OPTIONS = {

    number_of_shards: 1,
    analysis: {
      filter: {
        "autocomplete_filter" => {
          type: "edge_ngram",
          min_gram: 1,
          max_gram: 20
        }
      },
      analyzer: {
        "autocomplete" => {
          type: "custom",
          tokenizer: "standard",
          filter: [
            "lowercase",
            "autocomplete_filter"
          ]
        }
      }
    }
  }

end

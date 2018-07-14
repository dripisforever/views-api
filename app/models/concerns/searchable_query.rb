module SearchableQuery
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # Sync up Elasticsearch with PostgreSQL.
    after_commit :index_document, on: [:create, :update]
    after_commit :delete_document, on: [:destroy]

    settings INDEX_OPTIONS do
      mappings dynamic: 'false' do
        indexes :name, analyzer: 'autocomplete'
        # indexes :slug
      end
    end

    def self.search(q)
      __elasticsearch__.search(
        {
          query: {
            match_phrase: {
                name: q
            }
          },

          # query: {
          #   prefix: {
          #     name: q
          #   }
          # },

          # query: {
          #   terms: {
          #     name: q
          #   }
          # },
          # suggest: {
            # text: q,
            # name: { term: { size: 1, field: :name } },
          #   body: { term: { size: 1, field: :body } }
          # }
          # suggest: {
          #   text: q,
          #   title: { term: { size: 1, field: :title } },
          #   body: { term: { size: 1, field: :body } }
          # }
          # query: {
          #   match: {
          #     name: query
          #   }
          # }
        }
      )
    end
  end


  def as_indexed_json(options ={})
    self.as_json({
      only: [:name]
    })
  end

  def index_document
    ElasticsearchIndexWorker.perform_async('index', 'Query', self.id)
    # self.posts.find_each do |post|
    #   ElasticsearchIndexJob.perform_later('index', 'Post', post.id) if post.created_at?
    # end
  end

  def delete_document
    ElasticsearchIndexWorker.perform_async('delete', 'Query', self.id)
    # self.posts.find_each do |post|
    #   ElasticsearchIndexJob.perform_later('delete', 'Post', post.id) if post.created_at?
    # end
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
          min_gram: 1,
          max_gram: 20,
          filter: [
            "lowercase",
            "autocomplete_filter"
          ]
        }
      }
    }
  }

end

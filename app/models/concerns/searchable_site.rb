module SearchableSite
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # Sync up Elasticsearch with PostgreSQL.
    after_commit :index_document, on: [:create, :update]
    after_commit :delete_document, on: [:destroy]

    settings INDEX_OPTIONS do
      mappings dynamic: 'false' do
        indexes :url, analyzer: 'autocomplete'
        # indexes :slug
      end
    end

    def self.search(term)
      __elasticsearch__.search(
        {
          query: {
            term: {
              url: term
            }
          }
        }
      )
    end
  end


  def as_indexed_json(options ={})
    self.as_json({
      only: [:url]
    })
  end

  def index_document
    ElasticsearchIndexWorker.perform_async('index', 'Site', self.id)
    # self.posts.find_each do |post|
    #   ElasticsearchIndexJob.perform_later('index', 'Post', post.id) if post.created_at?
    # end
  end

  def delete_document
    ElasticsearchIndexWorker.perform_async('delete', 'Site', self.id)
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
          filter: [
            "lowercase",
            "autocomplete_filter"
          ]
        }
      }
    }
  }

end

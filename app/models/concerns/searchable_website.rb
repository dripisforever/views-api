module SearchableWebsite
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks
    # Sync up Elasticsearch with PostgreSQL.
    after_commit :index_document, on: [:create, :update]
    after_commit :delete_document, on: [:destroy]

    settings INDEX_OPTIONS do
      mappings dynamic: 'false' do
        indexes :name, analyzer: 'autocomplete'
        indexes :header
        indexes :body
        # indexes :slug
      end
    end

    def self.search(term)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: term,
              fields: ['name^10', 'header', 'body']
            }
          }
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
    ElasticsearchIndexJob.perform_later('index', 'Website', self.id) if self.published?
  end

  def delete_document
    ElasticsearchIndexJob.perform_later('delete', 'Website', self.id) if self.published?
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

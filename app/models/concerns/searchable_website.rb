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
        indexes :title
        indexes :body
        indexes :url
        indexes :liked
        indexes :disliked
        # indexes :slug
      end
    end

    def self.search(term)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: term,
              fields: ['title^9', 'url^10', 'body']
            }
          },
          highlight: {
              tags_schema: 'styled',
              pre_tags: ['<em class="broski">'],
              post_tags: ['</em>'],
              fields: {
                title:  { number_of_fragments: 5, fragment_size: 25, fragmenter: 'simple'},
                # body:   { fragmenter: 'simple', phrase_limit: 100, number_of_fragments: 5}
                url:    { number_of_fragments: 5, fragment_size: 25, fragmenter: 'simple'},
                body:   { fragmenter: 'simple', fragment_size: 100,  number_of_fragments: 3}
                # body:   { fragmenter: 'simple', boundary_scanner: 10, max_fragment_length: 10 }
              }
          }
        }
      )
    end
  end


  def as_indexed_json(options ={})
    self.as_json({
      only: [:url, :title, :body, :liked, :disliked]
    })
  end

  def index_document
    ElasticsearchIndexWorker.perform_async('index', 'Website', self.id) if self.created_at?
  end

  def delete_document
    ElasticsearchIndexWorker.perform_async('delete', 'Website', self.id) if self.created_at?
  end

  INDEX_OPTIONS = {

    number_of_shards: 1,
    analysis: {
      filter: {
        "autocomplete_filter" => {
          type: "edge_ngram",
          stop_words: '_english_',
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

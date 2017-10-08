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
        # indexes :slug
      end
    end

    def self.search(term)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: term,
<<<<<<< HEAD
              fields: ['title^9', 'name', 'body^10']
=======
              fields: ['title^10', 'name', 'body^9']
>>>>>>> f987269c9f32fe98a4ee6576e22828893945ac68
            }
          },

          highlight: {
<<<<<<< HEAD
              pre_tags: ['<em>'],
              post_tags: ['</em>'],
              # tags_schema: 'styled',
              fields: {
                title:  { number_of_fragments: 5, fragment_size: 25, fragmenter: 'simple'},
                body:   { fragmenter: 'simple', phrase_limit: 100, number_of_fragments: 5}
                # url: { }
                # fragmenter: "simple"
=======
              tags_schema: 'styled',
              fields: {
                title:    { number_of_fragments: 1 },
                body: { number_of_fragments: 1 },
                url: { fragment_size: 50 }
>>>>>>> f987269c9f32fe98a4ee6576e22828893945ac68
              }
          }
        }
      )
    end
  end


  def as_indexed_json(options ={})
    self.as_json({
      only: [:title, :body, :url]
    })
  end

  def index_document
    ElasticsearchIndexJob.perform_later('index', 'Website', self.id) if self.created_at?
  end

  def delete_document
    ElasticsearchIndexJob.perform_later('delete', 'Website', self.id) if self.created_at?
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

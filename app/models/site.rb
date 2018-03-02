class Site < ApplicationRecord
  belongs_to :batch
  include SearchableSite
  # after_commit :scrape, :on => :create
  # attr_accessor :url, :body, :title

  # after_save    { ElasticsearchIndexWorker.perform_async('index', 'Site', self.id) }
  # after_destroy { ElasticsearchIndexWorker.perform_async('delete', 'Site', self.id) }

  # def scrape
  #   SiteWorker.perform_async(self.id)
  # end
end

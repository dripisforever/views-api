class SiteWorker
  include Sidekiq::Worker

  def perform(site_id)
    errors = []
    site = Site.find(site_id)
    batch = site.batch
    crawler = Crawler.new(site.url, batch.keywords.split(","), batch.neg_keywords.split(","), batch.min_keywords)
  end
end

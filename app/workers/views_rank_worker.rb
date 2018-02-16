class ViewsRankWorker
  include Sidekiq::Worker

  def perform(site_id)
    errors = []
    site = Site.find(site_id)
    batch = site.batch
    crawler = Crawler.new(site.url)
    crawler.crawl
    # crawler.views_rank

    site.scrapped = true
    site.save
  end
end

class SiteWorker
  include Sidekiq::Worker
  # sidekiq_options queue: :crawler, backtrace: true
  # sidekiq_options queue: 'crawler', retry: false, backtrace: true, :dead => false
  sidekiq_options queue: 'crawler', retry: false, backtrace: true
  # sidekiq_options retry: 0
  def perform(site_id)
    errors = []
    site = Site.find(site_id)
    batch = site.batch
    crawler = Crawler.new(site.url)
    # crawler.crawl
    # crawler.views_crawl
    crawler.crawl_selenium
    # Sorting PreVIEWS by ViewsRANK
    # crawler.views_rank


    # site.valid_site = crawler.isActive
    # site.business = crawler.isBusiness
    site.title = crawler.title
    # site.urls = crawler.urls
    # site.body  = crawler.body
    site.scrapped = true
    site.save
  end
end

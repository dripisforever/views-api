class SiteWorkerTwo
  include Sidekiq::Worker
  sidekiq_options queue: 'crawler_two', retry: false, backtrace: true

  def perform(site_id)
    errors = []
    site = Site.find(site_id)
    crawler = Crawler.new(site.url)
    # crawler.crawl
    # crawler.views_crawl
    crawler.crawl_selenium
    site.title = crawler.title
    # site.body  = crawler.body
    site.scrapped = true
    site.save
  end
end

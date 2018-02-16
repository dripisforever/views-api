class SiteWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(site_id)
    errors = []
    site = Site.find(site_id)
    batch = site.batch
    crawler = Crawler.new(site.url)
    # crawler.crawl
    crawler.views_crawl
    # crawler.views_rank
    site.valid_site = crawler.isActive
    site.business = crawler.isBusiness
    site.title = crawler.title
    # site.urls = crawler.urls
    # site.body  = crawler.body
    site.scrapped = true
    site.save
    # render json: site
    # if crawler.matched_keywords.count > 0
    #   crawler.matched_keywords.each do |key, value|
    #     matched_links = site.matched_links.build(:keyword => key, :link_text => value.to_s, :link_url => value.uri.to_s)
    #     matched_links.save
    #   end
    #
    #   crawler = nil
    # end
  end
end

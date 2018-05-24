class Crawler::SpiderOne < Crawler::Spider
  sidekiq_options queue: :spider_one,
                  retry: true,
                  backtrace: true

  def next_type
    @type ||= 'SpiderOne'
  end
end

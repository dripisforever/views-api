desc 'recrawl urls'
task 'recrawl:urls' => :environment do
  # batch_size = ENV.fetch['SCRAPE_BATCH_SIZE', 200].to_i
  batch_size = 200
  begin
    # loop do
      start = Time.now
      # Website.scrape_batch(batch_size)
      # Website.scrape_batch_with_open_uri(batch_size)
      Website.scrape_batch_with_selenium(batch_size)
      # Website.update_data
      # Site.scrape_batch(batch_size)
      Rails.logger.info "Done scraping batch of #{batch_size} at #{((Time.now.to_f - start.to_f) / batch_size.to_f).round(2)}seconds/page"
      # sleep 10 if Website.count.zero?
    # end
  rescue GracefulShutdown
    raise
  end
end

desc 'scrape urls'
task 'crawl:urls' => :environment do
  # batch_size = ENV.fetch['SCRAPE_BATCH_SIZE', 200].to_i
  batch_size = 200
  begin
    # loop do
      start = Time.now
      Website.scrape_batch(batch_size)
      # Website.scrape_batch_with_open_uri(batch_size)
      # Website.scrape_batch_with_selenium(batch_size)
      # Site.scrape_batch(batch_size)
      Rails.logger.info "Done scraping batch of #{batch_size} at #{((Time.now.to_f - start.to_f) / batch_size.to_f).round(2)}seconds/page"
      # sleep 10 if Website.count.zero?
    # end
  rescue GracefulShutdown
    raise
  end
end

desc 'scrape all urls'
task 'pages:scrape', [:limit] => :environment do |t, args|
  limit = args[:limit] || 20

  done = 0

  Website.scrape_batch(limit) do |completed_response|
    done += 1

    if done % 10 == 0
      puts "Completed #{done}"
    end
  end

  # NotificationMailer.notify_success(limit).deliver! if NotificationMailer.configured?
end

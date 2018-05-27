require 'nokogiri'
require 'watir'
require 'selenium-webdriver'

class SeleniumScrape

  attr_reader :batch_size, :queue, :processed, :concurrency
  def initialize(batch_size)
    @batch_size = batch_size
    @queue, @processed = Queue.new, Queue.new
    @concurrency = 200
  end

  def scrape_batch
    pages = Website.reserve_batch_for_scraping(batch_size)
    pages.each { |p| queue << p }

    concurrency.times do
      Thread.new do
        until queue.empty?
          page = queue.pop
          processed << [page, fetch_response(page.url)]
        end
      end
    end

    pages.count.times do
      page, response = processed.pop

      page.scraped!(response)
      yield(response) if block_given?
    end
  rescue GracefulShutdown
    queue.clear
    pages.each { |p| p.unlock! if p.locked? }
    raise
  rescue => e
    Rails.logger.error([e.message] + e.backtrace)
    raise e
  end



  def fetch_response(url)
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'no-sandbox'])
    driver  = Selenium::WebDriver.for(:chrome, options: options)
    driver.manage.timeouts.implicit_wait = 10
    begin
      driver.navigate.to("http://#{url}")
      # driver.get("http://#{@url}")
      site = Website.find_or_create_by(url: url)
      @title = Nokogiri::HTML(driver.page_source).css("title").text
      @body  = Nokogiri::HTML(driver.page_source).text

      # Saving to Website Model
      site.title = @title
      # site.body  = @body
      # site.image = @image
      # site.outbound_links = @links.outbound_links
      # site.inbound_links  = @links.inbound_links
      site.save
      driver.quit

    rescue  Net::OpenTimeout, SocketError, Timeout::Error, Errno::EMFILE, Errno::ECONNREFUSED, Net::ReadTimeout, Errno::ECONNRESET, Errno::EINVAL => e
      driver.quit
      puts "Crawler failed to parse: #{e}"

    end
  end

end

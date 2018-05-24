# require 'user_agent_randomizer'
# require 'timeout'
require 'nokogiri'
require 'watir'
require 'selenium-webdriver'

class Crawl::Base < Page::Url

  def agent
    @agent ||= defaults
  end

  def driver
    @driver ||= defaults
  end

  def get
    page = agent.get(url)
    # page = Selenium
    return page if page.code == '200'

    if page.code == '301' || page.code == '302'
      page = agent.get(url.gsub('http://','https://'))

      return page if page.code == '200'
    end

    raise Mechanize::ResponseCodeError.new(page, 'Not 200')
  end

  def clear
    driver.quit
  end

  def post(params, headers = '')
    # TODO: change it back to cache_key when built
    VCR.use_cassette(File.join(cache_vcr, params.to_query + headers), record: :new_episodes) do
      # Rails.cache.fetch(build_path, params.to_query + headers) do
      @agent = defaults
      @agent.post(url, params, headers)
    end
  end

  private

  def get_with_vcr(record)
    # TODO: change it back to cache_key when built
    VCR.use_cassette(cache_vcr, record: record) do
      # Rails.cache.fetch(build_path) do
      @agent = defaults
      @agent.get(url)
    end
  end

  def cache_vcr
    File.join(host, date, md5)
  end

  def defaults
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'no-sandbox'])
    driver  = Selenium::WebDriver.for(:chrome, options: options)
    driver.manage.timeouts.implicit_wait = 10
  end

end

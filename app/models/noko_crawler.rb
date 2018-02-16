require 'nokogiri'
require 'open-uri'
require 'uri'
require 'watir'

class NokoCrawler

  attr_reader :urls_processed

  def initialize(url)

    unless url_valid? url
      puts "Initial URL is not valid.\n"
      exit
    end

    @urls_processed = []
    @urls_not_processed = []
    @urls_external = []
    @urls_invalid = []
    @urls_error = []
    @url_last_scanned = nil

    # define ignore list, array of regex
    # todo: turn this into an argument
    @urls_ignore_list = [
      /posts\/.*?\/comments\/.*?\/new/
    ]

    process_initial_url url

    # add first url to process queue
    @urls_not_processed << url

  end

  # method to start scanning
  def start_scan
    while !@urls_not_processed.empty?
      url = @urls_not_processed.shift
      urls = scan_url url
      process_scanned_urls urls
    end
  end

  # simple url validation
  def url_valid?(url)
    (url =~ URI::regexp).nil? ? false : true
  end

  # processes first url and sets instance variables
  def process_initial_url(url)
    @url_initial = url
    uri = URI(@url_initial)
    @url_host = uri.host
    @url_scheme_host = "#{uri.scheme}://#{uri.host}"
  end

  # scans url from queue using nokogiri
  def scan_url(url)

    @urls_processed << url
    @url_last_scanned = url

    begin

      # todo: check for content type:
      # page = open(url)
      # page.content_type
      # examples:
      # "text/html"
      # "image/png"
      browser = Watir::Browser.new(:chrome, headless: true)
      browser.goto(url)

      doc = Nokogiri::HTML(browser.html)
    rescue
      @urls_error << url
      return []
    end

    doc.css('a').collect {|a| a['href']}
  end

  # loop through scanned urls, post-process, ignore, store
  def process_scanned_urls(urls)

    # todo: does not work with urls that start with '../'
    # todo: remove trailing slash?
    # todo: ignore/remove anchors from urls?

    urls.each do |url|

      # ignore urls that start with '#'
      if url =~ /^#/
        next
      # ignore urls that start with 'javascript:'
      elsif url =~ /^javascript:/
        next
      # ignore urls that start with 'mailto:'
      elsif url =~ /^mailto:/
        next
      # check for nil links
      elsif url.nil?
        next
      end

      # check for internal link, starts with '/'
      if url =~ /^\//
        url = @url_scheme_host + url
      end

      # check for relative links beginning with '../'
      if url =~ /^\.\.\//
        unless @urls_invalid.include? url
          @urls_invalid << url
        end
        next
      end

      # check for relative links
      unless url =~ /^(http|https):\/\//
        url = url_with_trailing_slash(@url_last_scanned) + url
      end

      # check for invalid urls
      unless url_valid? url
        unless @urls_invalid.include? url
          @urls_invalid << url
        end
        next
      end

      # check if url has already been scanned
      if @urls_processed.include? url
        next
      end

      # check if url is queued to be processed
      if @urls_not_processed.include? url
        next
      end

      # check ignore list
      url_ignored = false
      @urls_ignore_list.each do |regex|
        if regex =~ url
          url_ignored = true
          break
        end
      end
      if url_ignored
        next
      end

      uri = URI(url)

      # check for external link
      if @url_host != uri.host
        unless url_hosts_same? uri.host, @url_host
          unless @urls_external.include? url
            @urls_external << url
          end
          next
        end
      end

      # add url to list to process
      @urls_not_processed << url

    end

  end

  # method to check if scanned domains are the same, or internal
  # note: ericlondon.com == www.ericlondon.com
  def url_hosts_same? (url_1, url_2)

    if url_1.nil? || url_2.nil?
      return false
    end

    url_1_split = url_1.split '.'
    url_2_split = url_2.split '.'

    # note: checks for domains with at least 1 period;
    # example: example.com
    # localhost will not work
    unless url_1_split.size > 1 && url_2_split.size >2
      return false
    end

    url_1_base = url_1_split.pop(2).join('.')
    url_2_base = url_2_split.pop(2).join('.')

    return url_1_base == url_2_base

  end

  # method that return the last scanned url with a trailing slash
  # note: removes "index.html" from url structure: http://example.com/test/index.html
  def url_with_trailing_slash(url)
    if url[-1..-1] == '/'
      return url
    else
      # remove everything after last '/'
      uri = URI(url)
      uri_path_parts = uri.path.split '/'
      uri_path_parts.pop
      return uri.scheme + '://' + uri.host + uri_path_parts.join('/') + '/'
    end
  end

end

# ruby crawler.rb
# noko = NokoCrawl.new 'https://vk.com'
# noko.start_scan
# p noko.urls_processed.inspect

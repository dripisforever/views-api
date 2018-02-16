require 'rubygems'
require 'timeout'
require 'addressable/uri'
require 'mechanize'
require 'to_regexp'
require 'nokogiri'
require 'watir'

class Crawler
# class Crawler < ActiveRecord::Base
  # after_commit :views_crawl, on: :create
  attr_reader :matched_keywords, :quantity_to_match
  def initialize(url)
    @url = url
    # @title = title
    @urls_processed = []
    @urls_not_processed = []
    @urls_external = []
    @urls_invalid = []
    @urls_error = []
    @url_last_scanned = []

    # define ignore list, array of regex
    # todo: turn this into an argument
    @urls_ignore_list = [
      /posts\/.*?\/comments\/*?\/new/
    ]
    
    # add first url to process queue
    @urls_not_processed << url
  end

  def domain_name?(url)

    domain_regex = /^https:\/\//

    if !domain_regex.match(url).nil?
      status = true
    else
      @url = ('https://'||'https://www.' || 'http://www.') +url
      status = false
    end

    if !domain_regex.match(@url).nil?
      status = true
    else
      status = false
    end
    status
  end

  def crawl
    if domain_name?(@url)
      agent = Mechanize.new
      agent.max_history = 1
      agent.read_timeout = 4
      agent.open_timeout = 4
      agent.log = Logger.new("mmech.log")
      agent.user_agent_alias = 'Mac Safari'
      page = nil

      begin
        Timeout.timeout(1000) do
          page = agent.get(@url)
        end

        page.content_type

        if /html/.match(page.content_type).nil?
          @isActive = false
          @title = page.content_type
          return
        end
      rescue Timeout::Error
        @isActive = false
        return
      rescue StandartError => e
        #if exception.response_code == '400' || exception.response_code == '500
          puts e
          @isActive = false
          return
        #end
      end

      @isActive = true
      @title = page.title
      url_uri = Addressable::URI.parse(@url.to_s)

      page.links.each do |link|
        begin
          link.uri.to_s
          link_uri = Addressable::URI.parse(link.uri.to_s)
          # second_level_crawl = Nokogiri::HTML(link.uri).css("a")
        rescue StandartError
          #puts StandardError
          next
        end

        # @keywords.each do |keyword|
        #   str = "/" + keyword.to_s + "/"
        #   regexp = str.to_regexp
        #   begin
        #     (regexp.match(link.uri.to_s).nil? and regexp.match(link.text).nil?)
        #   rescue StandardError
        #     next
        #   end
        #
        #   if link_uri.host.nil? or url_uri.host == link_uri.host
        #     if regexp.match(link.uri.to_s).nil? and regexp.match(link.text).nil?
        #       puts link.uri
        #       puts link.text
        #     else
        #       @matched_keywords[keyword] = link
        #     end
        #   else
        #     next
        #   end
        # end
      end
      # @isBusiness = true if @matched_keywords.values.uniq.count >= @quantity_to_match
    else
      @isActive = false
    end

    # @neg_keywords.each do |neg|
    #   str2 = "/" + neg.to_s + "/"
    #   regexp2 = str2.to_regexp
    #   begin
    #     regexp2.match(page.parser.xpath('/html/body')[0].content).nil?
    #   rescue StandardError
    #     next
    #   end
    #
    #   if regexp2.match(page.parser.xpath('/html/body')[0].content).nil?
    #     next
    #   else
    #     @isBusiness = false
    #   end
    # end

    agent.shutdown
    agent = nil
  end

  def scrap
    agent = Mechanize.new
    page = agent.get(@url)
    # page.links.each do |link|
    #   @body = link.text
    #   @all_urls = link
    # end
    page.links
    page.body
  end

  def views_crawl
    browser = Watir::Browser.new(:chrome, headless: true, open_timeout: 60, read_timeout: 60)
    browser.goto(@url)
    current_url = browser.url
    # browser.wai
    page     = Nokogiri::HTML(browser.html)
    @title   = page.css("title").text
    # @body    = page.css("body").text
    @urls    = page.css("a").map {|element| element["href"]}.compact
    # outside_urls = @urls.match(\current_url\)?
  end

  def scan_url(url)

  end

  def inside
    @inside
  end


  def all_urls
    @all_urls
  end

  def isBusiness
    @isBusiness
  end

  def urls
    @urls
  end

  def keywords
    @keywords
  end

  def isActive
    @isActive
  end

  def matched_keywords
    @matched_keywords
  end

  def title
    @title
  end

  def body
    @body
  end

  def neg_keywords
    @neg_keywords
  end
end

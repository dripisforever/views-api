require 'typhoeus/adapters/faraday'
class Website < ApplicationRecord
	# has_many :urls
	belongs_to :user
	
	has_many :views
	has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  has_many :dislikes, dependent: :destroy
  has_many :dislikers, through: :dislikes, source: :user
  # has_many :comments, dependent: :destroy
	# has_many :taggings, dependent: :destroy
  # has_many :tags, through: :taggings

	include SearchableWebsite

	scope :get_page, -> (page, per_page = 5) {
    includes(:title, :body, :urls).order(created_at: :desc).paginate(page: page, per_page: per_page)
  }
	scope :locked, -> { where("locked_at IS NOT NULL") }
	scope :not_locked, -> { where(locked_at: nil) }
	scope :unscraped, -> { where(fetched: false).not_locked }
	scope :scraped, -> { where(fetched: true) }
	scope :errored, -> { scraped.where('error_code IS NOT NULL OR error_message IS NOT NULL') }
	scope :timeout, -> { scraped.where("error_message = 'timeout'") }
	scope :not_errored, -> { scraped.where(error_code: nil, error_message: nil) }
	serialize :links, Hash

	def self.reset_attributes
    {
      fetched: false,
      locked_at: nil,
      error_code: nil,
      error_message: nil
    }
  end
  delegate :reset_attributes, to: 'self.class'

	def locked?
		locked_at
	end

	def errored
		error_code.present? || error_message.present?
	end

	def self.reserve_batch_for_scraping(limit)
    pages_subquery = unscraped.limit(limit).order(:id).select(:id).lock(true).to_sql
    db_time_now = Time.now.utc

    find_by_sql [<<-SQL, db_time_now, db_time_now]
      UPDATE websites SET locked_at = ?, updated_at = ?
      WHERE id IN (#{pages_subquery})
      RETURNING *
    SQL
  end

	def self.hydra
		@hydra ||= Typhoeus::Hydra.new(max_concurrency: 200)
	end
	delegate :hydra, to: 'self.class'

	def self.scrape_batch(batch_size)
		pages = reserve_batch_for_scraping(batch_size)
		pages.each do |page|
			hydra.queue(request = page.new_request)
			request.on_complete do |response|
				page.scraped!(response)
				yield(response) if block_given?
			end
		end

		hydra.run
	rescue GracefulShutdown
    hydra.abort
    pages.each { |p| p.unlock! if p.locked? }
    raise
  rescue => e
    Rails.logger.error([e.message] + e.backtrace)
    # NotificationMailer.notify_error(e.message).deliver! if NotificationMailer.configured?

    raise e
	end

	def self.scrape_batch_with_open_uri(batch_size)
		OpenUriScrape.new(batch_size).scrape_batch
	end

	def self.scrape_batch_with_selenium(batch_size)
		SeleniumScrape.new(batch_size).scrape_batch
	end

	CSV_COLUMNS = %w(url)
  def self.write_report!(file_path = Rails.root.join('tmp/report.csv'))
    File.open(file_path, 'wb') do |file|
      file.write(generate_report)
    end
  end

  def self.generate_report(limit = nil)
    CSV.generate do |csv|
      csv << CSV_COLUMNS

      not_errored.limit(limit).order((CSV_COLUMNS - ['url']).map { |c| "#{c} desc" }.join(', ')).each do |page|
        csv << CSV_COLUMNS.map { |c| page.__send__(c) }
      end
    end
  end

	def scraped!(response, raise_errors = false)
		# Librato.measure('scrape.request.time', response.total_time * 1000) unless response.total_time.zero?

    # return handle_scrape_error(response) unless response.success?

    begin
      # scraped_attributes = parse_and_find_rg_links(response)
			scraped_attributes = parse_and_find_rg_links(response.body)
    rescue => e
      Librato.increment('scrape.error')
      tap(&:mark_fetched).update_attributes!(error_message: { :exception => e }.to_yaml)
      raise e if raise_errors
    else
      Librato.increment('scrape.success')

      tap(&:mark_fetched).update_attributes!(scraped_attributes.merge!(error_code: nil, error_message: nil))
    end
	end

	def handle_scrape_error(response)
		Librato.increment('scrape.error')

    mark_fetched

    if response.timed_out?
      Librato.increment('scrape.error.timeout')
      update_attributes!(error_message: "timeout")
    elsif response.code == 0
      Librato.increment('scrape.error.unknown')
      update_attributes!(error_message: response.return_message)
    else
      Librato.increment('scrape.error.http')
      update_attributes!(error_message: nil, error_code: response.code)
    end
	end

	def new_request
		# options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'no-sandbox'])
		# driver  = Selenium::WebDriver.for(:chrome, options: options)
		# driver.manage.timeouts.implicit_wait = 10
		# driver.navigate.to("http://#{url}")

		Typhoeus::Request.new(url, followlocation: true, timeout: ENV.fetch('HTTP_TIMEOUT', 20).to_i, headers: request_headers)
	end

	def request_headers
		{
			'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9',
      'Cache-Control' => 'max-age=0', 'Accept-Language' => 'en-US,en;q=0.8'
		}
	end

	def mark_fetched
		self.attributes = reset_attributes
		self.fetched = true
		self.locked_at = nil
	end

	def unlock!
		self.locked_at = nil
		save!
	end

	private

	def parse_and_find_rg_links(body)
		Librato.measure('parse_and_find_rg_links') do
      PageParser.new(body).parse_and_find_rg_links
    end
	end
end

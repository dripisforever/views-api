class HomeController < ApplicationController
  require 'csv'

  def index
  end

  def settings
    @settings = Setting
  end

  def update_settings
    Setting.keywords = params[:keywords]
    Setting.min_keywords = params[:min_keywords].to_s
    Setting.neg_keywords = params[:neg_keywords]
    redirect_go :back
  end

  def single_crawl
    @settings = Setting
  end

  def multi_crawl
    @settings = Setting
  end

  def do_crawl
    @settings = Setting
    @keywords = []
    @keywords = @settings.keywords.split(",")
    @neg_keywords = @settings.neg_keywords.split(",")
    @crawler = Crawler.new(params[:url], @keywords, @neg_keywords, Setting.min_keywords)
    logger.debug "Keywords: " + @keywords.to_s
    @crawler.crawl
    @a = @crawler.isBusiness
    logger.debug "Called Business"
  end

  def import_csv
    # @settings = Setting
    # @keywords = @settings.keywords
    # @neg_keywords = @settings.neg_keywords

    if request.post? && params[:inputfile].present?
      infile = params[:inputfile].read
      n, errors = 0, []
      batch = Batch.create(:status => :started)

      if batch.save
        BatchWorker.perform_async(batch.id, infile)
        # redirect_to batch_index_path
        # render json: @batchWorker
        # render json: batch
        render json: batch
      end
      # render json: @batchWorker

    end
  end
end

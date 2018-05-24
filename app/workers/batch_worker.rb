class BatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'crawler', retry: false, backtrace: true

  def perform(batch_id, csv_file)
    batch = Batch.find(batch_id)
    n = 0
    options = {chunk_size: 10}
    SmarterCSV.process(csv_file, options) do |chunk|
      chunk.each do |row|

        site = batch.sites.build(:url => row[:url])
        site.save
        SiteWorker.perform_async(site.id)
        # Crawler::SiteWorkerOne.perform_async(site.id)
      end
    end
    # CSV.parse(csv_file) do |row|
    #   n+=1
    #   next if n == 1 or row.join.blank?
    #   site = batch.sites.build(:url => row[1])
    #   site.save
    # end

    batch.finish_time = DateTime.now
    batch.status = :complete
    batch.save if batch.valid?
  end

  # def multiple_workers
  #   site = Site.all
  #   site.
  # end

  def crawler_number
    data = ['SiteWorkerOne', 'SiteWorkerTwo']
    @type ||= data.each {|crawler| puts crawler}
  end
end



# CSV.parse(csv_file) do |row|
#   n+=1
#   next if n == 1 or row.join.blank?
#   site = batch.sites.build(:url => row[1])
#   site.save
#   SiteWorker.perform_async(site.id)
# end

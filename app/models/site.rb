class Site < ApplicationRecord
  belongs_to :batch
  include SearchableSite
  after_commit :scrape, :on => :create

  def scrape
    SiteWorker.perform_async(id)
  end
end

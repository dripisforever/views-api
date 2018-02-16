class SitesController < ApplicationController
  def index
    sites = Site.all.order("created_at ASC")
    render json: sites
  end

  def batch_list
    batches = Batch.all
    render json: batches
  end
end

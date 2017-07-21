class SearchAutocompleteController < ApplicationController
  def index
    results   = Elasticsearch::Model.search(params[:term], [User, Website])
    @users    = results.select { |result| result["_type"] == 'user' }
    @websites = results.select { |result| result["_type"] == 'website' }
    # @websitys = Website.search(params[:term]).records.to_a
    # render json: @websitys
  end
end

class SearchAutocompleteController < ApplicationController
  def index
    results   = Elasticsearch::Model.search(params[:q], [User, Website]).response
    # @users    = results.select { |result| result["_type"] == 'user' }
    # @websites = results.select { |result| result["_type"] == 'website' }

    # render json: @users
    # @websitys = Website.search(params[:term]).records.to_a
    # render json: @websitys
    render json: results
  end
end

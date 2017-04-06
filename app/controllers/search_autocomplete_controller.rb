class SearchAutocompleteController < ApplicationController
  def index
    results = Elasticsearch::Model.search(params[:term],  User)
    @users = results.select { |result| result["_type"] == 'user' }
    render json: @users, serializer: SearchSerializer
  end
end

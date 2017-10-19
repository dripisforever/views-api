class Websites::SearchController < ApplicationController
  # before_action :require_query

  def index

      websites = Website.search(query_term).paginate(page: params[:page], per_page: 10).response
      render json: websites, meta: pagination_dict(websites), status: 200

  end

  private
    def query_term
      params[:q]
    end

    # def require_query
    #   not_found unless params[:q]
    # end
end

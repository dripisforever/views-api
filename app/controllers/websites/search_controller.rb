class Websites::SearchController < ApplicationController
  # before_action :require_query

  def show

      @websites = Website.search(query_term)
      render json: @websites, status: 200

  end

  private
    def query_term
      params[:q]
    end

    # def require_query
    #   not_found unless params[:q]
    # end
end

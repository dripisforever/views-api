class Users::SearchesController < ApplicationController
  # before_action :require_query

  def show

      @users = User.search(query_term).results
      render json: @users, status: 200

  end

  private
    def query_term
      params[:q]
    end

    # def require_query
    #   not_found unless params[:q]
    # end
end

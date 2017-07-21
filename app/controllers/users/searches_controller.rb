class Users::SearchesController < ApplicationController
  before_action :require_query

  def show
    if params[:q].present?
      users = User.search(query_term)
      render json: users, status: 200
    end
  end

  private
    def query_term
      params[:q]
    end

    def require_query
      not_found unless params[:q]
    end
end

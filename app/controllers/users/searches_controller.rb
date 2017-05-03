class Users::SearchesController < ApplicationController
  before_action :require_query

  def show
    @users = User.search(params[:q])

    render json: @users
  end

  private

  def require_query
    not_found unless params[:q]
  end
end

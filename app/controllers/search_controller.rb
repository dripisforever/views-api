class SearchController < ApplicationController
  before_action :beautify_url
  # layout "simple"

  def show
    @users        = User.search(query_term).records.to_a
    # render json: @users
    @site_records = Website.search(query_term).paginate(page: params[:page]).records
    @websites     = @site_records.to_a.select { |post| post.published? }
    # @tags = Tag.search(query_term).records
  end

  def users
    @users = User.search(query_term).response
    render json: @users
  end

  def websitess
    @website = Website.search(query_term).response
    render json: @website
  end

  private

    def beautify_url
      if params[:search].present?
        case params[:action]
        when "show"
          redirect_to search_url(q: params[:search][:q])
        when "users"
          redirect_to search_users_url(q: params[:search][:q])
        end
      end
    end

    def query_term
      params[:q] || ''
    end
end

class SearchController < ApplicationController
  before_action :beautify_url
  # layout "simple"

  def show
    # @query        = Query.search(query_term).results
    @users        = User.search(query_term).results
    # @users        = User.search(query_term).paginate(page: params[:page], per_page: 1).records
    # @websites     = Website.search(query_term).results
    @websites = Website.search(query_term).paginate(page: params[:page], per_page: 5).results

    @site = Site.search(query_term).results
    # render json: @users
    render :show => '/search/show', :formats => :json
    # render json: @users
    # @site_records = Website.search(query_term).paginate(page: params[:page]).records
    # @websites     = @site_records.to_a.select { |post| post.published? }
    # @tags = Tag.search(query_term).records
  end

  def users
    # @users = User.search(query_term).response

    # PAGINATION
    # @users = User.search(query_term).paginate(page: params[:page], per_page: 1)
    # @users = User.search(query_term).paginate(page: params[:page], per_page: 1).results
    # @users = User.search(query_term).paginate(page: params[:page], per_page: 1).response
    @users = User.search(query_term).paginate(page: params[:page], per_page: 2).response
    render json: @users
    # render :users => '/search/users', :formats => :json
  end

  def queries
    @queries = Query.search(query_term).paginate(page: params[:page], per_page: 10).results
    # render json: @query
    render :queries => '/search/queries', :formats => :json
  end

  def websites
    # @website = Website.search(query_term).response
    @website = Website.search(query_term).paginate(page: params[:page], per_page: 2).results
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

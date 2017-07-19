class SearchController < ApplicationController

  def show
    @website_records = Website.search(query_term).paginate(page: params[:page]).records
    @websites = @website_records.to_a.select { |website| website.published? }
    @users = User.search(query_term).records.to_a
  end

  def users
    @users = User.search.(query_term).records.to_a
  end

  private

    def query_term
      params[:q] || ""
    end
end

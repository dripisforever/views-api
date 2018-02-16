class QueriesController < ApplicationController
  def index
    @queries = Query.all
    render json: @queries
  end

  def create
    # @query = Query.new
    if Query.where(name: params[:q]).present?
    # if @query = Query.where("name ILIKE ?", "%#{params[:q]}%").present?
      # @query = Query.where(printed_count: printed_count).first_or_create!
      @query = Query.find_by(name: params[:q])
      # @query = Query.where("name ILIKE ?", "%#{params[:q]}%")
      # User.likes.where(query_id: query.id).first_or_create!
      @query.update_attributes(query_params)
      render json: @query
    else
      @query = Query.create(name: params[:q])
      render json: @query
    end

  end

  def destroy
    @query = Query.find_by_id(params[:id])
    @query.destroy
    render json: @query
  end

  private
    def query_params
      params.permit(:name, :printed_count)
    end
end

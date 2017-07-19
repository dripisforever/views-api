class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @channels = Channel.all
    render json: @channels
    # if @channels.present?
    #   render json: @channels, serializer: ChannelSerializer, status: 200
    # end
  end

  def show
    @channel = Channel.includes(messages: [:author]).find(params[:id])
    # render json: @channel
  end
end

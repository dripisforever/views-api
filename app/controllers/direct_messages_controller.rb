class DirectMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @direct_messages = current_user.direct_messages
    # render 'api/direct_messages/index.json.jbuilder'
    # render json: @direct_messages, each_serializer: DirectMessageSerializer
  end

  def show
    @direct_message = DirectMessage
      .includes(:users, messages: [:author])
      .find(params[:id])
    # render 'api/direct_messages/show.json.jbuilder'
    # render json: @direct_message, serializer: Api::DirectMessageSerializer
  end

  def create
    users = params[:users].map { |user| User.find_by(username: user) }
      .push(current_user)
    title = users.sort.map(&:username).join(', ')
    @direct_message = DirectMessage.find_or_initialize_by(title: title)
    @direct_message.users = users
    # @direct_message = DirectMessage.find_or_initialize_by(title: params[:users].map { |user| User.find_by(username: user) }.push(current_user).sort.map(&:username).join(', ') )
    # @direct_message.users = params[:users].map { |user| User.find_by(username: user) }.push(current_user)
    if @direct_message.save
      # render 'api/direct_messages/show.json.jbuilder'
      # render json: @direct_message, serializer: Api::DirectMessageSerializer, status: 201
      render :show
    else
      render json: @direct_message.errors.full_messages, status: 422
    end
  end

  def destroy
    @direct_message = DirectMessage.find(params[:id])
    @direct_message.users = @direct_message.users.reject do |user|
      user == current_user
    end
    @direct_message.destroy if @direct_message.users.length <= 1
    render :show
  end

end

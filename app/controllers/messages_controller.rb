class MessagesController < ApplicationController
  before_action :authenticate_user!
  def index
    @messages = Message
      .where(postable_type: params[:postable_type])
      .find_by(postable_id: params[:postable_id])
    render json: @messages
  end

  # def index
  #   messages = Message.all
  #   render json: messages
  # end

  def show
    @message = Message.find(params[:id])
    render json: @message, serializer: MessageIdSerializer
  end

  def create
    @message = Message.new(message_params)
    @message.author_id = current_user.id
    if @message.save
      render json: @message, serializer: MessageSerializer
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def update
    @message = Message.find(params[:id])
    if @message.update(message_params)
      render :show
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    render json: @message
  end

  private

  def message_params
    params.permit(:body, :postable_id, :postable_type, :author_id)
  end
end

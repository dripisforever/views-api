class Websites::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.like!(@website)
    create_notification
    head 204
  end

  def destroy
    current_user.delete_like!(@website)
    head 204
  end

  private

    def set_post
      @website = Website.find(params[:website_id])
    end

    def create_notification
      unless current_user.id == @website.user.id
        notification = Notification.create!(actor: current_user, recipient: @website.user,
                             notifiable: @website, action_type: 'LIKE_WEBSITE')
        Notification::Broadcaster.new(notification, to: @website.user).broadcast
      end
    end
end

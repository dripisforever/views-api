class AvatarImagesController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update_attributes(user_params)
      render json: current_user, status: 200
    else
      render json: { errors: ['Oops something went wrong. Please try again'] }, status: 422
    end
  end

  private

    def user_params
      params.permit(:avatar, :username, :email, :password)
    end
end

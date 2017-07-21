class WebsitesController < ApplicationController
  # POST '/api/users/signup'
  # BODY: {
  #   email: String,
  #   username: String,
  #   password: String
  # }
  def create
    website = Website.new(website_params)
    if website.save
      render json: website, serializer: CurrentUserSerializer, status: 201
    else
      render json: { errors: website.errors.full_messages }, status: 422
    end
  end

  private

    def website_params
      params.permit(:name)
    end
end

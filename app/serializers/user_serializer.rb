class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar_url, :email, :created_at
  def avatar_url
    object.avatar_url
  end

  # def highlight
  #   object.highlight
  # end
end

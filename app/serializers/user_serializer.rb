class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar_url, :email

  def avatar_url
    object.avatar_url
  end
end

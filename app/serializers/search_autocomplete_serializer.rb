class SearchSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar_url, :url

  def avatar_url
    object.avatar_url
  end

  def url
    object.url
  end

end
json.users do |json|
  json.array! @users do |user|
    json.id user.id
    json.username user.username
    json.avatar_url user.avatar_url.present? ? user.avatar_url : image_path('default-avatar.svg')
    json.url user_path(user.slug)
  end
end

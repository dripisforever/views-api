class SearchSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar_url, :url

  def avatar_url
    object.avatar_url
  end

  def url
    object.url
  end

end

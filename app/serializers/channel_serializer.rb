class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :title, :owner_id, :created_at
  has_many :messages
  has_many :users, serializer: UserSerializer
  # def id
  #   {
  #     email: object.title,
  #     owner_id: object.owner_id,
  #     avatar_url: object.avatar_url
  #   }
  # end
end

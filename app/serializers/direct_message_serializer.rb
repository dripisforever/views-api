class Api::DirectMessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at
  # has_many :messages, serializer: MessageSerializer
  has_many :users, serializer: UserSerializer
  # def id
  #   {
  #     email: object.title,
  #     owner_id: object.owner_id,
  #     avatar_url: object.avatar_url
  #   }
  # end
end

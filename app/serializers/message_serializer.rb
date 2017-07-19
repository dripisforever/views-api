class MessageSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :body, :postable_type, :postable_id, :created_at
  belongs_to :author, serializer: UserSerializer
end

class MessageIdSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :body
  # 
  # def id
  #   object.id
  # end
  #
  # def author_id
  #   object.author_id
  # end
  #
  # def body
  #   object.body
  # end
end

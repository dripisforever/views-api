class QuerySerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at


  # def highlight
  #   object.highlight
  # end

  type 'things' # This needs to be overridden, otherwise it will print "hashie-mashes"
  attributes :id # For some reason the mapping below doesn't work with :id

  [:user_id, :active, :status].map{|a| attribute(a) {object[:_source][a]}}

  def id
    object[:_source].id
  end
end

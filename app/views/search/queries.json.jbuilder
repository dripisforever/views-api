json.queries do |json|
  json.hits do |json|
    json.hits do |json|
      json._source @queries do |query|
        json.id query.id
        json.name query.name
      end
    end
  end
end

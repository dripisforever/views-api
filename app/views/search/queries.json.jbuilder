json.queries do |json|
  json.hits do |json|
    json.hits do |json|
      json._source @queries do |query|
        json.id query.id
        json.name query.name
        # json.body query.body
        # json.highlight query.highlight
        # json.url website_path(website.slug)
      end
      # json.highlight @websites do |website|
      #   json.title website.title
      # end
    end
  end
end

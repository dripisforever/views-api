json.users do |json|
  json.hits do |json|
    json.hits do |json|
      json._source @users do |user|
        json.id user.id
        json.username user.username
        json.email user.email
        json.avatar_url user.avatar_url
        json.highlight user.highlight
        # json.url website_path(website.slug)
      end
    end
  end
end

# json.data do
#   json.name @users.hits.hits
# end

json.datas do
  json.name @users
end

# json.user @users do |user|
#   json.hits do |json|
#     json.hits do |json|
#       json._source do |json|
#         json.username user.username
#       end
#     end
#   end
# end

# json.websites do |json|
#   json.hits do |json|
#     json.hits do |json|
#       json._source @websites do |website|
#         json.id website.id
#         json.title website.title
#         json.highlight website.highlight
#         # json.url website_path(website.slug)
#       end
#     end
#   end
# end

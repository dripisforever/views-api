json.websites do |json|
  json.array! @websites do |website|
    json.id website.id
    json.name website.name
    # json.url website_path(website.slug)
  end
end

json.users do |json|
  json.array! @users do |user|
    json.id user.id
    json.username user.username
    json.avatar_url user.avatar_url.present? ? user.avatar_url : image_path('default-avatar.svg')
    # json.url user_path(user.slug)
  end
end

# json.websitys do |json|
#   json.array! @websitys do |website|
#     json.id website.id
#     json.name website.name
#     # json.url website_path(website.slug)
#   end
# end

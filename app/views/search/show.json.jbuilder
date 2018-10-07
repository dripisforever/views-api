# json.users do |json|
#   json.array! @users do |user|
#     json.id user.id
#     json.username user.username
#     json.avatar_url user.avatar_url.present? ? user.avatar_url : image_path('default-avatar.svg')
#     # json.url user_path(user.slug)
#   end
# end

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
      # json.highlight @users do |user|
      #   json.highlight user
      # end
    end
  end
end

json.websites do |json|
  json.hits do |json|
    json.hits do |json|
      json._source @websites do |website|
        json.id website.id
        json.url website.url
        json.title website.title
        json.body website.body
        json.highlight website.highlight
        json.liked website.liked
        json.disliked website.disliked
        # json.url website_path(website.slug)
      end
      # json.highlight @websites do |website|
      #   # json.title website.title
      #   json.snippet website.highlight do |json|
      #     json.body json.body
      #   end
      # end
    end
  end
end

json.sites do |json|
  json.hits do |json|
    json.hits do |json|
      json._source @sites do |site|
        # json.id website.id
        # json.title website.title
        json.url site.url
        # json.body website.body
        # json.highlight website.highlight
        # json.url website_path(website.slug)
      end
      # json.highlight @websites do |website|
      #   json.title website.title
      # end
    end
  end
end

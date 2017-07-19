class User < ApplicationRecord
  # include ActiveModel::Serialization
  has_many :posts, dependent: :destroy
  
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :views
  has_many :viewsed_posts, through: :views, source: :post

  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
            foreign_key: "follower_id",
            dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
            foreign_key: "followed_id",
            dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, dependent: :destroy, foreign_key: :recipient_id


  has_many :owned_channels,
            foreign_key: :owner_id,
            class_name: "User"

  has_many :channels,
            through: :channel_joins,
            source: :channel

  has_many :channel_joins, dependent: :destroy

  has_many :dm_joins

  has_many :direct_messages,
            through: :dm_joins,
            source: :direct_message

  has_many :owned_messages,
            foreign_key: :author_id,
            class_name: :Message

  has_many :messages,
            foreign_key: :author_id,
            class_name: :Message
  # attr_reader :password
  attr_accessor :password, :password_confirmation
  has_secure_password validations: false
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  USERNAME_REGEX = /\A[a-zA-Z0-9_-]{3,30}\z/
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: EMAIL_REGEX }, unless: :facebook_login?
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                      format: { with: USERNAME_REGEX, message: "should be one word" }, unless: :facebook_login?
  validates :password, presence: true, length: { minimum: 8 }, unless: :facebook_login?

  mount_uploader :avatar, AvatarUploader

  def self.authenticate(email_or_username, password)
    user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
    user && user.authenticate(password)
  end

  def like!(post)
    likes.where(post_id: post.id).first_or_create!
  end

  def dislike!(post)
    likes.where(post_id: post.id).destroy_all
  end

  def views!(post)

  end

  def follow(other_user)
    return false if self.id == other_user.id
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_ids.include?(other_user.id)
  end

  def facebook_login?
    facebook_id.present?
  end

  def self.search(query)
    self.where("username ILIKE ?", "%#{query}%")
  end

  def avatar_url
    if facebook_login? && avatar.url.nil?
      "https://graph.facebook.com/#{facebook_id}/picture?type=large"
    else
      avatar.url
    end
  end
end

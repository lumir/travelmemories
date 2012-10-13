class User < ActiveRecord::Base
  include AASM
  devise :database_authenticatable, :recoverable, :trackable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
  :authentications_attributes, :status

  has_many :authentications, dependent: :destroy

  has_many :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship",
    :foreign_key => "friend_id", :dependent => :destroy

  has_many :friends, :through => :friendships,
    :conditions => "accepted = true", :source => :friend

  has_many :followers, :through => :friendships,
    :conditions => "accepted = true", :source => :friend, :foreign_key => "friend_id"

  has_many :pending_friends, :through => :friendships,
    :conditions => "accepted = false", :foreign_key => "friend_id",
    :source => :friend
  has_many :pending_friends_inverse, :through => :inverse_friendships,
    :conditions => "accepted = false", :foreign_key => "user_id",
    :source => :user
  has_many :requested_friendships, :class_name => "Friendship",
    :foreign_key => "friend_id", :conditions => "accepted = false"


  accepts_nested_attributes_for :authentications, :allow_destroy => true


  aasm column: :status do
    state :completed
    state :incompleted, initial: true

    event :set_incompleted do
      transitions to: :incompleted
    end

    event :set_complete do
      transitions to: :completed, from: :incompleted
    end

    event :upgrade do
      transitions to: :completed, from: :incompleted
    end

    event :downgrade do
      transitions to: :incompleted, from: :completed
    end
  end

  def all_friends
    friends && followers
  end

  def friends_or_pending
    friends | pending_friends | pending_friends_inverse
  end

  def self.from_omniauth(auth, user = nil)
    Authentication.find_by_uid(auth["uid"]).try(:user) || create_from_omniauth(auth, user)
  end

  def self.create_from_omniauth(auth, user = nil)
    unless auth["provider"] == "facebook"
      user = find_or_create_by_email(auth["info"]["email"]) do |user|
        user.first_name = auth["info"]["first_name"]
        user.last_name = auth["info"]["last_name"]
        user.password = Devise.friendly_token[0,20]
      end
    end

    user.authentications.create(provider: auth["provider"], uid: auth["uid"], token: auth["credentials"]["token"], secret: auth["credentials"]["secret"])
    user
  end

  def get_friendship(user)
    result = Friendship.where("(user_id = #{user.id} AND friend_id = #{self.id}) OR (user_id = #{self.id} AND friend_id = #{user.id})")
    result.first
  end

  def pictures(result=[])
    authentication = has_authenticated?("facebook")
    Rails.cache.fetch(:pictures, expires: 1.hour) do
      result = if authentication
        begin
          FbGraph::User.me(authentication.token).albums.inject({}) do |acc, album|
            acc[album.name] = album.photos.map(&:source)
            acc
          end
        rescue
          []
        end
      end
    end
  end

  def facebook_friends
    auth = self.authentications.find_by_provider("facebook")
    subquery = "SELECT uid2 FROM friend WHERE uid1 = #{auth.uid}"
    query = "SELECT uid FROM user WHERE is_app_user=1 and uid IN (#{subquery})"
    friends_application = FbGraph::Query.new(query).fetch("#{auth.token}")
    facebook_friends_ids = friends_application.collect! {|friend| friend["uid"].to_s }
    users = User.joins(:authentications).where("authentications.uid IN (?)", facebook_friends_ids)
    users
  end

  def friends_in_facebook
    auth = self.authentications.find_by_provider("facebook")
    user = FbGraph::User.me("#{auth.token}")
    user.friends
  end

  def has_authenticated?(provider)
    authentications.find_by_provider(provider)
  end

  protected

  def password_required?
    (authentications.empty? || password.present?) && super
  end
end

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :trackable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  has_many :authentications, dependent: :destroy

  def self.apply_omniauth(auth)
    authentication = Authentication.find_by_uid(auth["uid"])
    if authentication.blank?
      user = User.find_or_create_by_email(auth["info"]["email"], first_name: auth["info"]["first_name"], last_name: auth["info"]["last_name"])
      authentication = Authentication.new(provider: auth["provider"], uid: auth["uid"], token: auth["credentials"]["token"], secret: auth["credentials"]["secret"], user_id: user.id)
      authentication.save
    else
      user = authentication.user
    end
    user
  end

  def albums
    authentication = has_authenticated?("facebook")
    return FbGraph::User.me(authentication.token).albums if authentication
    return []
  end

  def has_authenticated?(provider)
    authentications.find_by_provider(provider)
  end

  protected

  def password_required?
    (authentications.empty? || password.present?) && super
  end
end

class User < ActiveRecord::Base
  # Devise options - Start
    devise :database_authenticatable, :recoverable, :trackable, :omniauthable
  # Devise options - Ends

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  has_many :authentications, dependent: :destroy

  def self.apply_omniauth(auth)
    authentication = Authentication.find_by_uid(auth["uid"])
    if authentication.blank?
      user = User.new(first_name: auth["info"]["first_name"], last_name: auth["info"]["last_name"], email: auth["info"]["email"])
      user.save
      authentication = Authentication.new(provider: auth["provider"], uid: auth["uid"], token: auth["credentials"]["token"], secret: auth["credentials"]["secret"], user_id: user.id)
        authentication.save
    else
      user = authentication.user
    end
    user
  end

  protected

  def password_required?
    (authentications.empty? || password.present?) && super
  end


end

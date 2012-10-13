class User < ActiveRecord::Base
  include OmniauthAuthenticationHelper
  # Devise options - Start
    devise :database_authenticatable, :recoverable, :trackable, :omniauthable
  # Devise options - Ends

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  protected

  def password_required?
    (authentications.empty? || password.present?) && super
  end
end

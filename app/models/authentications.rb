class Authentications < ActiveRecord::Base
  # Model attibutes accessibles - Start
  attr_accessible :provider, :secret, :token, :uid, :user_id
  # Model attibutes accessibles - Ends

  # Model relationships - Start
  belongs_to :user
  # Model relationships - Ends

  # Rails validations - Start
  validates :provider, presence: true
  validates :uid, presence: true
  # Rails validations - Ends
end

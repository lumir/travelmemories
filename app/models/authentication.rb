class Authentication < ActiveRecord::Base
  attr_accessible :provider, :secret, :token, :uid, :user_id

  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
end

class Invitation < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :uid, :user_id
end

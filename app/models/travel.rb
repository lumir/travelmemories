class Travel < ActiveRecord::Base

  attr_accessible :user_id, :location, :start_date, :end_date
  
  has_many :checkins
  belongs_to :user
end

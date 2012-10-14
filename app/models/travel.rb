class Travel < ActiveRecord::Base

  attr_accessible :user_id, :location, :start_date, :end_date

  has_many :checkins
  has_many :photos
  belongs_to :user
end

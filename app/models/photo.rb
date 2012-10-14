class Photo < ActiveRecord::Base
  attr_accessible :travel_id, :url
  belongs_to :travel
end

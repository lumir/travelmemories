class TravelsController < ApplicationController

  def index
    
  end

  def create
    @travel = Travel.new(location: params[:location], start_date: params[:start_date], end_date: params[:end_date], user_id: current_user.id)  
    if @travel.save
      checkins_ids = params[:checkins_ids].split(",")
      checkins_ids.each do |checkin_id|
        unless checkin_id.blank?
          fq_checkin = current_user.foursquare_checkin(checkin_id)
          checkin = Checkin.new(travel_id: @travel.id, name: fq_checkin.venue.name, country: fq_checkin.venue.location.country, city: fq_checkin.venue.location.city)
          checkin.save
        end
      end
      flash[:notice] = "Travel added succesfully"
    else
      flash[:notice] = "Travel not added"
    end
    redirect_to :back
  end

end

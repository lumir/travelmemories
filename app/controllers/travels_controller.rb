class TravelsController < ApplicationController

  def create
    @travel = Travel.new(location: params[:location], start_date: Date.parse(params[:start_date]), end_date: Date.parse(params[:end_date]), user_id: current_user.id)  
    if @travel.save
      
    end
  end

end

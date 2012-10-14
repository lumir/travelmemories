class PublicPagesController < ApplicationController
  def timeline
    @user = User.find params[:id]
    @travels = @user.travels
  end

  def travel_show
    @user = User.find params[:user_id]    
    @travel = @user.travels.find params[:id]
  end
end

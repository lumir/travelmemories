class PublicPagesController < ApplicationController
  def timeline
    @user = User.find params[:id]
    @travels = @user.travels
  end

  def show_travel
    @user = User.find params[:user_id]
    @travel = @user.travels.find params[:id]
  end
end

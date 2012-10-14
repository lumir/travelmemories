class PublicPagesController < ApplicationController
  def timeline
    @user = User.find params[:id]
    @travels = @user.travels
  end

  def share_on_facebook
    if params[:view] == "timeline"
      message = "Check my Awesome Timeline"
    else
      message = "Check my Awesome Travel"
    end
    link = "#{request.host}#{params[:page]}"
    current_user.post_in_facebook_wall(message, link)
    flash[:success] = "Shared in facebook successfully"
    redirect_to :back
  end

  def show_travel
    @user = User.find params[:user_id]
    @travel = @user.travels.find params[:id]
  end
end

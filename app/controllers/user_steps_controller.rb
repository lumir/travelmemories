class UserStepsController < ApplicationController
  include Wicked::Wizard
  before_filter :authenticate_user!
  skip_before_filter :user_incompleted, only: [:show]

  steps :networks, :friends, :places

  def show
    @user = current_user
    case step
    when :places
      redirect_to user_step_path("networks") and return if @user.incompleted?
      @fq_object = current_user.foursquare_checkins
      @places = []
      @fq_object.items.each do |item_lvl_1|
        begin
        @places = ["#{item_lvl_1.venue.location.country},#{item_lvl_1.venue.location.city}"]
        rescue
          []
        end
      end
      @photos = current_user.pictures
    when :friends
      user_incompleted
        @pending_requests = current_user.requested_friendships
        @users = User.all - current_user.all_friends - current_user.friends_or_pending - [current_user]
        @facebook_friends = current_user.friends_in_facebook
    end
    render_wizard
  end

  def get_checkins
    @checkins = []
    if params[:simple].present?
      country = params[:location]
      city = params[:location]
      current_user.foursquare_checkins(params[:start_date], params[:end_date]).items.each do |item_lvl_1|
        if item_lvl_1.venue.location.country.downcase.include?(country.downcase) || item_lvl_1.venue.location.city.downcase.include?(city.downcase)
          @checkins << item_lvl_1
        end
      end    
    else
      country = params[:location].split(",").first
      city = params[:location].split(",").last
      current_user.foursquare_checkins(params[:start_date], params[:end_date]).items.each do |item_lvl_1|
        if item_lvl_1.venue.location.country == country && item_lvl_1.venue.location.city == city
          @checkins << item_lvl_1
        end
      end    
    end    
    
    
    respond_to do |format|
      format.js do
        render json: @checkins.to_json
      end
    end
  end

  def update
    @user = current_user
    @user.attributes = params[:user]
    render_wizard @user
  end

  private

  def redirect_to_finish_wizard
    redirect_to @user
  end
end

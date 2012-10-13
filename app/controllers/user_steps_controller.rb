class UserStepsController < ApplicationController
  include Wicked::Wizard
  before_filter :authenticate_user!
  skip_before_filter :user_incompleted

  steps :networks, :friends, :places

  def show
    @user = current_user
    case step
    when :friends
      @user.upgrade! if @user.incompleted?
      @pending_requests = current_user.requested_friendships
      @users = User.all - current_user.all_friends - current_user.friends_or_pending - [current_user]
      @facebook_friends = current_user.friends_in_facebook
    end
    render_wizard
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

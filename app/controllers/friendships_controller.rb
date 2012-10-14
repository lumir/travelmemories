class FriendshipsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def new
    @pending_requests = current_user.requested_friendships
    @users = User.all - current_user.all_friends - current_user.friends_or_pending - [current_user]
    @facebook_friends = current_user.friends_in_facebook
  end

  def create
    @friendship = current_user.friendships.build(params[:friendship])
    @friendship.save
    flash[:notice] = "A friendship invitation was sent to this friend"
    redirect_to :back
  end

  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.update_attribute(:accepted,true)
      flash[:notice] = "Friendship created successfully"
    else
      flash[:notice] = "Friendship cannot be accepted"
    end
    redirect_to :back
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      flash[:notice] = "A friendship invitation was sent to this friend"
    else
      flash[:error] = "friendship cannot be removed"
    end
    redirect_to :back
  end

  def invite
    @ids = params[:ids]
    if @ids.present? and @ids.any?
      @ids.each do |id|
        current_user.wall_post(id)
      end
      flash[:notice] = "An invitation has been sent."
    else
      flash[:error] = "No user found, try picking a user."
    end
    redirect_to :back
  end

end

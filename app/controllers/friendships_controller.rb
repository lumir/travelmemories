class FriendshipsController < ApplicationController

  def new
    @pending_requests = current_user.requested_friendships
    @users = User.all - current_user.all_friends - current_user.friends_or_pending - [current_user]
  end

  def create
    @friendship = Friendship.new(user_id: current_user.id, friend_id: params[:user_id], accepted: false)
    @friendship.save
    flash[:notice] = "A friendship invitation was sent to this friend"
    redirect_to :back
  end

  def update
    @friendship = Friendship.find(params[:id])
    if @friendship.update_attribute(:accepted,true)
      flash[:notice] = "friendship created successfully" 
    else
      flash[:notice] = "friendship cannot be accepted" 
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

end

class FriendshipsController < ApplicationController

  def new
    @users = User.all - current_user.friends - current_user
  end

end

class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]

  def index
    if user_signed_in?
      redirect_to current_user.incompleted? ? user_step_path("networks") : travels_path
    end
  end

end

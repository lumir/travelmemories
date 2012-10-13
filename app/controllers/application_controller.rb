class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :user_incompleted

  def after_sign_in_path_for(resource)
    redirect_to resource
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def user_incompleted
    if user_signed_in?
      if current_user.authentications.count > 1 && current_user.incompleted?
        current_user.upgrade!
        redirect_to user_step_path("networks") and return
      end

      if current_user.incompleted?
        flash[:alert] = "Need add network"
        redirect_to user_step_path("networks") and return
      end
    end

  end

end

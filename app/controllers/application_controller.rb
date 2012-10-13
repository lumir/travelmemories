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
    redirect_to user_steps_path and return if current_user && current_user.incompleted?
  end
end

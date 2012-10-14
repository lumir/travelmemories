class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :user_incompleted

  def method_missing(provider)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth, current_user)
    sign_in @user, bypass: true
    if @user.authentications.count > 1 && @user.incompleted?
      @user.upgrade!
      redirect_to user_step_path("networks") and return
    end
    after_sign_in_path_for(travels_path) and return
  end
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :user_incompleted

  def method_missing(provider)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth, current_user)
    if auth["provider"] != "foursquare"
      redirect_to user_step_path(:networks)
    else
      sign_in @user
      redirect_to root_path
    end
  end
end

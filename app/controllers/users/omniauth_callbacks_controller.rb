class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def method_missing(provider)
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth, current_user)
    sign_in @user unless auth["provider"] == "facebook"
    flash[:notice] = "User signed in sucessfully"
    redirect_to root_path
  end
end

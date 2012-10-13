class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def method_missing(provider)
    auth = request.env["omniauth.auth"]
    @user = User.apply_omniauth(auth)
    sign_in @user
    flash[:notice] = "User signed in sucessfully"
    redirect_to root_path
  end

  # def failure
  #   redirect_to root_path, error: "Opps.."
  # end
end

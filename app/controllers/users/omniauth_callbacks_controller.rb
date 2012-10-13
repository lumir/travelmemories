class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def method_missing(provider)
    @user = User.find_for_oauth(provider, request.env["omniauth.auth"], current_user)
    if current_user
      if @user != current_user
        flash[:error] = "The account is already associated for another user"
      else
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: provider
      end
      flash.keep
      redirect_to root_path
    else
      if @user && @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: provider
        sign_in(@user, event: :authentication) unless user_signed_in?
        redirect_to root_path
      else
        session["devise.omniauth_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to root_path
      end
    end
  end

  # def failure
  #   redirect_to root_path, error: "Opps.."
  # end
end

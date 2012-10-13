module OmniauthAuthenticationHelper
  module ClassMethods

    def find_for_oauth(provider, oauth_attr, user)
      OauthAuthenticator.find_for_provider(provider, oauth_attr, user)
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.omniauth_data"]
          OauthAuthenticator.set_info_user(data, user)
        end
      end
    end
  end

  module InstanceMethods
    def has_authenticated?(provider)
      self.authentications.find_by_provider(provider)
    end

    def oauth_client(network_name)
      OauthAuthenticator.call("client", network_name, self)
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

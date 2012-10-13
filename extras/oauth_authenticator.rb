class OauthAuthenticator
  # Returns an authentication user based on the authentication paramenters
  def self.find_for_provider(network_name, oauth_attr, user)
    self.call("find", network_name, *[oauth_attr, user])
  end

  # Sets the user information depending on the provider that is received. In some providers we receive the email, in others we do not.
  # This method sets the user information accordingly based on the provider params we receive.
  def self.set_info_user(data, user)
    self.call("set_info", data['provider'], *[data, user])
  end

  # Dynamically calling the different methods of the required provider.
  # Notice that the attributes are expanded when calling the desired method method_name.
  def self.call(method_name, provider, *attr)
    begin
      const = Kernel.const_get("oauth_#{provider.downcase}".camelize)
      return const.send(method_name.to_sym, *attr)
    rescue Exception => e
      Rails.logger.error("*"*100)
      Rails.logger.error("Error while calling #{method_name} with provider #{provider}.")
      Rails.logger.error("Attributes: #{attr}")
      Rails.logger.error(e.message)
      Rails.logger.error(e)
    end
  end

  # this method may be overwrite if is need it
  def self.network_url(access_token)
    access_token["info"]["urls"][access_token["provider"].capitalize]
  end


  # ************************************************************************************
  # ************************************************************************************
  #  methods that needs to be overwrited by the different Oauth Authenticator instances.
  # ************************************************************************************
  # ************************************************************************************

  def find(*attr)
    #finds an authentication
    #raise "overwrite"
  end

  def set_info(*attr)
    #finds an authentication
    #raise "overwrite"
  end

  def client(*attr)
    #returns the client for a social network
    #raise "overwrite"
  end
end

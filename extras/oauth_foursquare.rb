class OauthFoursquare < OauthGeneric

  def self.network_url(access_token)
    "https://foursquare.com/user/"+access_token["uid"]
  end

end

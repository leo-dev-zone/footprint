module UsersHelper
  def app_status(user, app)
    status =
      if app == :twitter
        user.twitter && user.twitter.oauth_token && user.twitter.oauth_token_secret
      elsif app == :facebook
        user.facebook && user.facebook.oauth_token
      elsif app == :linkedin
        user.linkedin && user.linkedin.oauth_token && user.linkedin.oauth_token_secret
      end
    status ? 'ok' : 'not ok'
  end
end

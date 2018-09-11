class AuthorizeController < ApplicationController
  skip_authorize_resource

  def twitter
    oauth = AppAccounts::Twitter.first_or_create(user: current_user).client

    url = APP_CONFIG['application_url'] + '/authorize/twitter_callback'
    request_token = oauth.get_request_token(oauth_callback: url)

    session[:twitter_token] = request_token.token
    session[:twitter_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def twitter_callback
    app_account = current_user.twitter
    oauth = app_account.client

    request_token = OAuth::RequestToken.new(oauth, session[:twitter_token],
                                            session[:twitter_secret])
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    app_account.update_attributes(oauth_token: access_token.params[:oauth_token],
                                  oauth_token_secret: access_token.params[:oauth_token_secret])

    response = oauth.request(:get, '/account/verify_credentials.json',
                             access_token, { :scheme => :query_string })
    redirect_to edit_user_registration_path(current_user)
  end

  def facebook
    app_account = AppAccounts::Facebook.first_or_create(user: current_user)
    oauth = app_account.client

    url = APP_CONFIG['application_url'] + '/authorize/facebook_callback'

    redirect_to oauth.auth_code.authorize_url(client_id: app_account.api_key, redirect_uri: url, scope: 'publish_actions')
  end

  def facebook_callback
    app_account = current_user.facebook
    oauth = app_account.client

    url = APP_CONFIG['application_url'] + '/authorize/facebook_callback'
    access_token = oauth.auth_code.get_token(params[:code], redirect_uri: url, parse: :query)

    app_account.update_attributes(oauth_token: access_token.token)

    redirect_to edit_user_registration_path(current_user)
  end

  def linkedin
    oauth = AppAccounts::Linkedin.first_or_create(user: current_user).client

    url = APP_CONFIG['application_url'] + '/authorize/linkedin_callback'
    request_token = oauth.get_request_token(oauth_callback: url)

    session[:linkedin_token] = request_token.token
    session[:linkedin_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def linkedin_callback
    app_account = current_user.linkedin
    oauth = app_account.client

    request_token = OAuth::RequestToken.new(oauth, session[:linkedin_token],
                                            session[:linkedin_secret])
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

    app_account.update_attributes(oauth_token: access_token.params[:oauth_token],
                                  oauth_token_secret: access_token.params[:oauth_token_secret])

    response = oauth.request(:get, '/account/verify_credentials.json',
                             access_token, { :scheme => :query_string })

    redirect_to edit_user_registration_path(current_user)
  end
end

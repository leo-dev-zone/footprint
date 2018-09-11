module AppAccounts
  class Linkedin < AppAccount
    def config
      {
        :site => 'https://api.linkedin.com',
        :authorize_path => '/uas/oauth/authenticate',
        :request_token_path => '/uas/oauth/requestToken?scope=rw_nus',
        :access_token_path => '/uas/oauth/accessToken'
      }
    end

    def post(feed_entry)
      feed_entry = FeedEntryDecorator.decorate(feed_entry)
      share = {
        :title => feed_entry.title.to_str,
        :content => {
          :'submitted-url' => feed_entry.bitly_link,
          :'description' => feed_entry.content[0...256].to_str
        }
      }
      share[:content].merge!(:'submitted-image-url' => feed_entry.image_url) if feed_entry.image_url.present?

      client = LinkedIn::Client.new(api_key, api_secret)
      client.authorize_from_access(oauth_token, oauth_token_secret)
      client.add_share(share)
    end
  end
end

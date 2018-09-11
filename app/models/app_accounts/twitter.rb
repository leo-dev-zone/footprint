module AppAccounts
  class Twitter < AppAccount
    def config
      {
        site: 'http://twitter.com'
      }
    end

    def post(feed_entry)
      feed_entry = FeedEntryDecorator.decorate(feed_entry)

      twitter = ::Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
      begin
        twitter.update(feed_entry.twitter_body)
      rescue ::Twitter::Error::Unauthorized
        update_attributes(oauth_token: nil, oauth_token_secret: nil)
      end
    end
  end
end

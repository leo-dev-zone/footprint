module AppAccounts
  class Twitter < AppAccount
    def config
      {
        site: 'http://twitter.com'
      }
    end

    def post(feed_entry)
      feed_entry = FeedEntryDecorator.decorate(feed_entry)

      link = feed_entry.bitly_link
      via = 'via @' + APP_CONFIG['via']
      body_len = 140 - via.size - link.size - 5
      body = "#{feed_entry.content[0...body_len].to_str}... #{link} #{via}"

      twitter = ::Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
      begin
        twitter.update(body)
      rescue ::Twitter::Error::Unauthorized
        update_attributes(oauth_token: nil, oauth_token_secret: nil)
      end
    end
  end
end

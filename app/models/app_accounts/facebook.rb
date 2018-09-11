module AppAccounts
  class Facebook < AppAccount
    def config
      {
        site: 'https://graph.facebook.com',
        token_url: '/oauth/access_token'
      }
    end

    def client
      OAuth2::Client.new(api_key, api_secret, config)
    end

    def post(feed_entry)
      feed_entry = FeedEntryDecorator.decorate(feed_entry)
      post = {
        message: feed_entry.content.to_str,
        link: feed_entry.bitly_link,
        caption: feed_entry.author.to_str,
        name: feed_entry.title.to_str
      }
      post.merge!(picture: feed_entry.image_url) if feed_entry.image_url.present?

      me = FbGraph::User.me(oauth_token)
      begin
        me.feed!(post)
      rescue FbGraph::InvalidToken
        update_attributes(oauth_token: nil)
      end
    end
  end
end

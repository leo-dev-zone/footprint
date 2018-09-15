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
        # Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
        OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
        OpenURI::Buffer.const_set 'StringMax', 0

        begin
          remote_image = open(feed_entry.image_url) if feed_entry.image_url
        rescue OpenURI::HTTPError
          remote_image = nil
        end
        if remote_image
          reserved_for_media = twitter.configuration.characters_reserved_per_media + 1
          twitter.update_with_media(feed_entry.twitter_body(reserved_for_media), remote_image, {})
        else
          twitter.update(feed_entry.twitter_body)
        end
      rescue ::Twitter::Error::Unauthorized
        update_attributes(oauth_token: nil, oauth_token_secret: nil)
      end
    end
  end
end

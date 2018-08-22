class BitlyShortenUrl < Struct.new(:feed_entry_id)
  def perform
    begin
      feed_entry = FeedEntry.find(feed_entry_id)

      Bitly.use_api_version_3
      bitly_client = Bitly.new(feed_entry.user.bitly_username, feed_entry.user.bitly_apikey)

      feed_entry.create_bitly_link(bitly_client)
    rescue ActiveRecord::RecordNotFound
    end
  end
end

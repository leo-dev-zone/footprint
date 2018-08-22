class FeedEntry < ActiveRecord::Base
  attr_accessible :content, :guid, :title, :author, :published_at, :url, :bitly_link

  belongs_to :feed
  belongs_to :user

  def create_bitly_link
    unless self.bitly_link
      begin
        update_attributes(bitly_link: bitly_client.shorten(url).short_url)
      rescue BitlyError
      end
    end
  end

  private

  def bitly_client
    Bitly.use_api_version_3
    @bitly_client ||= Bitly.new(feed.user.bitly_username, feed.user.bitly_apikey)
  end
end

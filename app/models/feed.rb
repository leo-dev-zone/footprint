class Feed < ActiveRecord::Base
  attr_accessible :url, :user_id

  belongs_to :user
  has_many :feed_entries

  def update_from_feed
    feed = Feedzirra::Feed.fetch_and_parse(url)
    add_entries(feed.entries)
  end

  def self.update_all_from_feed
    feeds = Feedzirra::Feed.fetch_and_parse(Feed.all.map(&:url))
    feeds.each do |url, feed|
      Feed.find_by_url(url).send(:add_entries, feed.entries)
    end
  end

  private

  def add_entries(entries)
    entries.each do |entry|
      unless FeedEntry.exists?(guid: entry.id)
        feed_entries.create!(
          title: entry.title.sanitize,
          content: entry.content.sanitize,
          author: entry.author.sanitize,
          url: entry.url.gsub('&#38;', '&'),
          published_at: entry.published,
          guid: entry.id
        )
      end
    end
  end
end
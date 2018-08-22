class Feed < ActiveRecord::Base
  attr_accessible :title, :url

  belongs_to :user
  has_many :feed_entries, dependent: :destroy

  after_create :enqueue_fetching

  FETCH_INTERVAR  = 5.minutes

  def enqueue_fetching
    Delayed::Job.enqueue FeedFetchingJob.new(id, FETCH_INTERVAR)
  end

  def update_from_feed
    feed = Feedzirra::Feed.fetch_and_parse(url)
    update_attributes(title: feed.title.sanitize)
    add_entries(feed.entries)
  end

  def self.update_all_from_feed
    feeds = Feedzirra::Feed.fetch_and_parse(Feed.all.map(&:url))
    feeds.each do |url, feed|
      Feed.find_by_url(url).tap do |db_feed|
        db_feed.update_attributes(title: feed.title.sanitize)
        db_feed.send(:add_entries, feed.entries)
      end
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
          guid: entry.id.split('/').last
        )
      end
    end
  end
end

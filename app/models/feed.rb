class Feed < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  attr_accessible :title, :url

  validates :user, :url, presence: true
  validates :url, uniqueness: { scope: :user_id }

  belongs_to :user
  has_many :feed_entries, dependent: :destroy

  after_create :enqueue_fetching

  FETCH_INTERVAR  = 5.minutes

  def enqueue_fetching
    Delayed::Job.enqueue FeedFetchingJob.new(id, FETCH_INTERVAR)
  end

  def update_from_feed
    feed = Feedzirra::Feed.fetch_and_parse(url)
    if feed
      update_attributes(title: feed.title.sanitize)
      add_entries(feed.entries)
    end
  end

  def self.update_all_from_feed
    feeds = Feedzirra::Feed.fetch_and_parse(Feed.all.map(&:url))
    feeds.each do |url, feed|
      Feed.find_by_url(url).tap do |db_feed|
        db_feed.update_attributes(title: sanitize(feed.title))
        db_feed.send(:add_entries, feed.entries)
      end
    end
  end

  private

  def add_entries(entries)
    entries.each do |entry|
      entry_guid = entry.id.split('/').last
      unless feed_entries.exists?(guid: entry_guid)
        feed_entries.create!(
          title: sanitize(entry.title),
          content: sanitize(entry.content),
          author: sanitize(entry.author),
          image_url: FeedEntry.parse_image_url(entry.content),
          url: entry.url.gsub('&#38;', '&'),
          published_at: entry.published,
          guid: entry_guid
        )
      end
    end
  end
end

class FeedEntry < ActiveRecord::Base
  attr_accessible :content, :feed_id, :guid, :name, :published_at, :url

  belongs_to :feed
end

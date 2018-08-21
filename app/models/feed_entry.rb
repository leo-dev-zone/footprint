class FeedEntry < ActiveRecord::Base
  attr_accessible :content, :guid, :title, :author, :published_at, :url

  belongs_to :feed
end

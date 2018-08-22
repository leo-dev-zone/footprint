class FeedDecorator < Draper::Base
  decorates :feed

  def title
    h.sanitize(feed.title) || '(no title)'
  end
end

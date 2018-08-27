class FeedDecorator < Draper::Base
  decorates :feed

  def title
    h.sanitize(feed.title) || '(no title yet)'
  end

  def user
    feed.user.try(:email) || '-'
  end
end

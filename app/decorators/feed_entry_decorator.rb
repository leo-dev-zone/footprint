class FeedEntryDecorator < Draper::Base
  decorates :feed_entry

  %w(title author content).each do |method|
    define_method method do
      h.sanitize feed_entry.send(method)
    end
  end

  def link_to_original
    h.link_to 'Original URL', feed_entry.url
  end

  def link_to_bitly
    feed_entry.bitly_link ? h.link_to('Bitly URL', feed_entry.bitly_link) : 'not obtained'
  end

  def title_with_link
    url = feed_entry.bitly_link
    url ? h.link_to(title, url) : title
  end

  def feed_title
    feed_entry.feed.title.sub('Google Alerts - ', '')
  end

  def sent_at
    if feed_entry.sent_at
      feed_entry.sent_at
    else
      if feed_entry.enqueued_to_sending
        "Enqueued to push at #{feed_entry.enqueued_to_sending}"
      else
        'not sent yet'
      end
    end
  end

  def publish_button
    if !feed_entry.in_scheduler
      h.button_to 'Publish', h.publish_feed_entry_path(feed_entry), remote: true
    else
      h.button_to 'Unpublish', h.unpublish_feed_entry_path(feed_entry), remote: true
    end
  end

  def unpublish_link
    h.link_to 'Unpublish', h.unpublish_feed_entry_path(feed_entry), method: :post
  end
end

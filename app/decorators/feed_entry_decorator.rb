class FeedEntryDecorator < Draper::Base
  decorates :feed_entry

  %w(title author content).each do |method|
    define_method method do
      h.sanitize feed_entry.send(method)
    end
  end

  def link_to_original
    h.link_to 'Original URL', feed_entry.url, target: '_blank'
  end

  def link_to_bitly
    feed_entry.bitly_link ? h.link_to('Bitly URL', feed_entry.bitly_link, target: '_blank') : 'not obtained'
  end

  def title_with_link
    url = feed_entry.bitly_link
    url ? h.link_to(title, url, target: '_blank') : title
  end

  def feed_title
    h.sanitize(feed_entry.feed.title.sub('Google Alerts - ', ''))
  end

  def sent_at
    if feed_entry.sent_at
      feed_entry.sent_at
    else
      if feed_entry.enqueued_to_sending
        "enqueued - #{feed_entry.enqueued_to_sending_at}"
      else
        'not sent yet'
      end
    end
  end

  def publish_button(application = nil)
    text = application ? application.to_s : 'all'

    if !feed_entry.in_scheduler || (application && !feed_entry.publish_to[application])
      h.button_to "Publish to #{text}", h.publish_feed_entry_path(feed_entry, app: application), remote: true
    else
      h.button_to "Unpublish from #{text}", h.unpublish_feed_entry_path(feed_entry, app: application), remote: true
    end
  end

  def unpublish_link
    h.link_to 'Unpublish', h.unpublish_feed_entry_path(feed_entry), method: :post
  end

  def twitter_body(reserved_chars = 0)
    link = feed_entry.bitly_link || ''
    via = 'via @' + APP_CONFIG['via']
    body_len = 140 - reserved_chars - via.size - link.size - 5
    "#{feed_entry.content[0...body_len].to_str}... #{link} #{via}"
  end
end

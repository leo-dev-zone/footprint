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
end

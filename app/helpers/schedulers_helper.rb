module SchedulersHelper
  def all_microformats(feed_entry, only = nil, &block)
    feed_entry.publish_to.keys.each do |app|
      yield "shared/microformats/#{app}", app if only.nil? || only == app
    end
  end
end

class FeedFetchingJob < Struct.new(:feed_id, :interval)
  def perform
    begin
      feed = Feed.find(feed_id)
      feed.update_from_feed

      Delayed::Job.enqueue(FeedFetchingJob.new(feed_id, interval), 0, interval.from_now)
    rescue ActiveRecord::RecordNotFound
    end
  end
end

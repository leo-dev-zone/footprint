class SendingJob < Struct.new(:feed_entry_id)
  def perform
    begin
      feed_entry = FeedEntry.find(feed_entry_id)

      # TODO Perform sending actions

      feed_entry.update_attributes(sent_at: Time.zone.now, enqueued_to_sending: false)
    rescue ActiveRecord::RecordNotFound
    end
  end
end

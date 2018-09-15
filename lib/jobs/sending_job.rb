class SendingJob < Struct.new(:feed_entry_id)
  def perform
    begin
      feed_entry = FeedEntry.find(feed_entry_id)

      AppAccounts::AppAccount::APPS.each do |app|
        if (account = feed_entry.user.send(app)) && feed_entry.publish_to[app] == true
          account.post(feed_entry)
        end
      end

      feed_entry.update_attributes(sent_at: Time.zone.now, enqueued_to_sending: false)
    rescue ActiveRecord::RecordNotFound
    end
  end
end

class EnqueuedToSendingAtToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :enqueued_to_sending_at, :datetime
  end
end

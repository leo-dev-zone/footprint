class AddEnqueuedToSendingToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :enqueued_to_sending, :boolean, default: false
  end
end

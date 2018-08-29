class AddInSchedulerAndSentAtToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :in_scheduler, :boolean, default: false
    add_column :feed_entries, :sent_at, :datetime
  end
end

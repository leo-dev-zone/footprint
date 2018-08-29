class AddInSchedulerSinceToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :in_scheduler_since, :datetime
  end
end

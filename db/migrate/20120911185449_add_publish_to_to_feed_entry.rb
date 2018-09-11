class AddPublishToToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :publish_to, :text
  end
end

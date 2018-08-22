class AddBitlyLinkToFeedEntry < ActiveRecord::Migration
  def change
    add_column :feed_entries, :bitly_link, :string
  end
end

class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.text :content
      t.text :url
      t.datetime :published_at
      t.string :guid
      t.integer :feed_id

      t.timestamps
    end
  end
end

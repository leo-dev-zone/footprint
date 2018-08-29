class FeedEntriesController < ApplicationController
  load_and_authorize_resource :feed_entry, only: [:publish, :unpublish]
  respond_to :js

  def publish
    publish_unpublish(true)
  end

  def unpublish
    publish_unpublish(false)
  end

  private

  def publish_unpublish(publish)
    @feed_entry = FeedEntryDecorator.decorate(@feed_entry)

    published = @feed_entry.in_scheduler
    @feed_entry.update_attributes(in_scheduler: publish, in_scheduler_since: publish ? Time.zone.now : nil) if publish == !published
    render 'publish_status'
  end

end

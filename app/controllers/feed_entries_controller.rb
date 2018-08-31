class FeedEntriesController < ApplicationController
  load_and_authorize_resource :feed_entry, only: [:edit, :cancel_edit, :update, :publish, :unpublish]
  respond_to :js

  def edit
    @feed_entry = FeedEntryDecorator.decorate(@feed_entry)
    respond_with(@feed_entry)
  end

  def cancel_edit
    @feed_entry = FeedEntryDecorator.decorate(@feed_entry)
    render 'update'
  end

  def update
    @feed_entry = FeedEntryDecorator.decorate(@feed_entry)
    @feed_entry.update_attributes(params[:feed_entry])
    respond_with(@feed_entry)
  end

  def publish
    publish_unpublish(true)
    render 'publish_status'
  end

  def unpublish
    publish_unpublish(false)
    respond_to do |format|
      format.html { redirect_to scheduler_path }
      format.js { render 'publish_status' }
    end
  end

  private

  def publish_unpublish(publish)
    @feed_entry = FeedEntryDecorator.decorate(@feed_entry)

    published = @feed_entry.in_scheduler
    @feed_entry.update_attributes(in_scheduler: publish, in_scheduler_since: publish ? Time.zone.now : nil) if publish == !published
  end

end

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
    publish_unpublish(@feed_entry, true, params[:app].try(:to_sym))
    @feed_entry.create_bitly_link_delayed
    render 'publish_status'
  end

  def unpublish
    publish_unpublish(@feed_entry, false, params[:app].try(:to_sym))
    respond_to do |format|
      format.html { redirect_to scheduler_path }
      format.js { render 'publish_status' }
    end
  end

  private

  def publish_unpublish(feed_entry, publish, app)
    @feed_entry = FeedEntryDecorator.decorate(feed_entry)

    published = @feed_entry.in_scheduler

    attributes = {}

    if publish
      attributes.merge!(in_scheduler: true, in_scheduler_since: Time.zone.now)
      if app.nil?
        attributes.merge!(publish_to: AppAccounts::AppAccount::APPS.inject({}) { |_, app| _.merge(app.to_sym => true) })
      else
        attributes.merge!(publish_to: @feed_entry.publish_to.merge(app => true))
      end
    else
      if app.nil? || (@feed_entry.publish_to.keys - [app]).empty?
        attributes.merge!(in_scheduler: false, in_scheduler_since: nil, publish_to: {})
      else
        attributes.merge!(publish_to: @feed_entry.publish_to.delete_if { |key, value| key == app })
      end
    end

    @feed_entry.update_attributes(attributes)
  end

end

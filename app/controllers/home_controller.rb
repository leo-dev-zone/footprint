class HomeController < ApplicationController
skip_before_filter :authenticate_user!, :only => [ :index ]

  def feed
    @feed_entries = FeedEntryDecorator.decorate(
      FeedEntry.accessible_by(current_ability).order('published_at DESC').page(params[:page]))
  end

  def index
  end
end

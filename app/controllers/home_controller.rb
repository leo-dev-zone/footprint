class HomeController < ApplicationController
  def index
    @feed_entries = FeedEntryDecorator.decorate(FeedEntry.accessible_by(current_ability).order('published_at DESC').page(params[:page]))
  end
end

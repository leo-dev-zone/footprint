class HomeController < ApplicationController
  def index
    @feed_entries = FeedEntryDecorator.decorate(FeedEntry.accessible_by(current_ability).page(params[:page]))
  end
end

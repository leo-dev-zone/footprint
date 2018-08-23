class FeedsController < ApplicationController
  load_and_authorize_resource :feed
  respond_to :html

  def index
    @feeds = FeedDecorator.decorate(@feeds)
    respond_with @feeds
  end

  def show
    @feed = FeedDecorator.decorate(@feed)
    respond_with @feed
  end

  def new
    respond_with @feed
  end

  def edit
    respond_with @feed
  end

  def create
    @feed.user = current_user
    if @feed.save
      flash[:notice] = 'Feed was successfully created.'
    end
    respond_with @feed
  end

  def update
    if @feed.update_attributes(params[:feed])
      flash[:notice] = 'Feed was successfully updated.'
    end
    respond_with @feed
  end

  def destroy
    @feed.destroy
    flash[:notice] = 'Feed was successfully destroyed.'
    respond_with @feed
  end
end

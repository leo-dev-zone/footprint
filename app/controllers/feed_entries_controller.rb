class FeedEntriesController < ApplicationController
  before_filter :get_feed

  # GET /feed_entries
  # GET /feed_entries.json
  def index
    @feed_entries = FeedEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feed_entries }
    end
  end

  # GET /feed_entries/1
  # GET /feed_entries/1.json
  def show
    @feed_entry = FeedEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed_entry }
    end
  end

  # DELETE /feed_entries/1
  # DELETE /feed_entries/1.json
  def destroy
    @feed_entry = FeedEntry.find(params[:id])
    @feed_entry.destroy

    respond_to do |format|
      format.html { redirect_to feed_entries_url }
      format.json { head :no_content }
    end
  end

  private

  def get_feed
    @feed = Feed.find(params[:feed_id])
  end
end

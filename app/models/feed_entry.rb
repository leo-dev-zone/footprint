class FeedEntry < ActiveRecord::Base
  attr_accessible :content, :guid, :title, :author, :published_at, :url, :bitly_link,
    :in_scheduler, :in_scheduler_since, :sent_at, :enqueued_to_sending

  belongs_to :feed
  belongs_to :scheduler

  after_create :create_bitly_link_delayed

  scope :first_pushed, order('in_scheduler_since')
  scope :last_pushed, order('in_scheduler_since DESC')
  scope :scheduled, where(in_scheduler: true)
  scope :not_sent, where(sent_at: nil)
  scope :enqueued, where(enqueued_to_sending: true)
  scope :not_enqueued, where(enqueued_to_sending: false)

  def create_bitly_link_delayed
    Delayed::Job.enqueue BitlyShortenUrl.new(id)
  end

  def create_bitly_link(bitly_client)
    unless self.bitly_link
      update_attributes(bitly_link: bitly_client.shorten(url).short_url)
    end
  end

  def user
    feed.user
  end
end

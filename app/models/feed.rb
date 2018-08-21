class Feed < ActiveRecord::Base
  attr_accessible :url, :user_id

  belongs_to :user
  has_many :feed_entries
end

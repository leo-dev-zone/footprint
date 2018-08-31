class Scheduler < ActiveRecord::Base
  attr_accessible :days_of_week, :push_at_from, :push_at_to, :push_rate_from, :push_rate_to

  validates :days_of_week, length: {is: 7}
  validates :push_rate_from, :numericality => {only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 24.hours}
  validates :push_rate_to, :numericality => {only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 24.hours}
  validates :user, presence: true

  belongs_to :user
  has_many :feed_entries, through: :user

  before_save do
    self.push_rate_to = self.push_rate_from if self.push_rate_to < self.push_rate_from
  end

  after_save do
    self.class.initialize_scheduler_queue_if_needed
  end

  def can_send?(time)
    can_send_in_weekday?(time.wday) && in_pushing_range?(time)
  end

  def randomized_delay
    rand(push_rate_from..push_rate_to)
  end

  private

  def can_send_in_weekday?(wday)
    days_of_week[wday] == '1' ? true : false
  end

  def in_pushing_range?(time)
    from, to = %w(from to).map do |constraint| Time.zone.parse(
      "#{time.strftime('%Y-%m-%d')}T#{send(:"push_at_#{constraint}").strftime('%H:%M:%S')}#{time.strftime('%z')}",
      '%Y-%m-%dT%H:%M:%S%z')
    end
    from <= time && time <= to
  end

  class << self
    def enqueue(run_at)
      Delayed::Job.enqueue(SchedulerJob.new, run_at: run_at, queue: 'scheduler')
    end

    def initialize_scheduler_queue_if_needed
      if Delayed::Job.where(queue: 'scheduler').count == 0
        enqueue(Time.zone.now)
      end
    end
  end
end

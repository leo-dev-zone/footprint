class Scheduler < ActiveRecord::Base
  attr_accessible :days_of_week, :push_at_from, :push_at_to, :push_rate_from, :push_rate_to

  validates :days_of_week, length: {is: 7}
  validates :push_rate_from, :numericality => {only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 24.hours}
  validates :push_rate_to, :numericality => {only_integer: true, greater_than_or_equal_to: 1.minute, less_than_or_equal_to: 24.hours}

  before_save do
    self.push_rate_to = self.push_rate_from if self.push_rate_to < self.push_rate_from
  end

  def works_today
    works_in_weekday(Time.zone.now.wday)
  end

  def in_pushing_range(time = Time.zone.now)
    from, to = push_range_for_today
    from <= time && time <= to
  end

  def randomized_delay
    rand(push_rate_from..push_rate_to)
  end

  private

  def works_in_weekday(wday)
    days_of_week[wday] == '1' ? true : false
  end

  def push_range_for_today
    now = Time.zone.now
    %w(from to).map do |constraint| Time.zone.parse(
      "#{now.strftime('%Y-%m-%d')}T#{send(:"push_at_#{constraint}").strftime('%H:%M:%S')}#{now.strftime('%z')}",
      '%Y-%m-%dT%H:%M:%S%z')
    end
  end
end

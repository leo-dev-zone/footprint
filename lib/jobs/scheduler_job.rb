class SchedulerJob
  def perform
    Scheduler.all.each do |scheduler|
      if true # TODO If no sending enqueued yet for this scheduler

        if scheduler.can_send?(delay.from_now)
          # TODO Run sending queue in `delay.from_now` time
          # TODO And mark as enqueued for sending
        end
      end
    end

    Scheduler.enqueue(1.minute.from_now)
  end
end

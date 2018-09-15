class SchedulerJob
  def perform
    Scheduler.all.each do |scheduler|
      if scheduler.feed_entries.enqueued.count == 0
        delay = scheduler.randomized_delay

        if scheduler.can_send?(delay.from_now)

          feed_entry = scheduler.feed_entries.scheduled.not_sent.not_enqueued.first_pushed.first
          if feed_entry
            pp "ID #{feed_entry.id} added to the queue"
            Delayed::Job.enqueue(SendingJob.new(feed_entry.id), run_at: delay.from_now, queue: 'sending')
            feed_entry.update_attributes(enqueued_to_sending: true, enqueued_to_sending_at: delay.from_now)
          end
        end
      end
    end

    Scheduler.enqueue(1.minute.from_now)
  end
end

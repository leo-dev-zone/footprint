User.where(role: 'admin').destroy_all
User.create!({email: 'admin@example.com', password: 'H9f83hf0h0', role: 'admin', bitly_username: '-', bitly_apikey: '-'}, without_protection: true)

Scheduler.destroy_all
Scheduler.create!(
  {
    days_of_week: '0000000',
    push_at_from: Time.zone.now.beginning_of_day,
    push_at_to: Time.zone.now.end_of_day,
    push_rate_from: 1.hour,
    push_rate_to: 15.hours
  }, without_protection: true)

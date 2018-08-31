User.where(role: 'admin').destroy_all
User.create!({email: 'admin@example.com', password: 'H9f83hf0h0', role: 'admin', bitly_username: '-', bitly_apikey: '-'}, without_protection: true)

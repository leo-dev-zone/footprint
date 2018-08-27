User.find_all_by_role('admin').each(&:destroy)
User.create!({email: 'admin@example.com', password: 'H9f83hf0h0', role: 'admin', bitly_username: '-', bitly_apikey: '-'}, without_protection: true)

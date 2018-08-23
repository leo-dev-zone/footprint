User.find_all_by_role('admin').destroy_all
User.create!(email: 'admin@example.com', password: 'H9f83hf0h0', role: 'admin', bitly_username: '-', bitly_apikey: '-')

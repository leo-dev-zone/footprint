
set :faye_pid, "#{deploy_to}/shared/pids/faye.pid"
set :faye_config, "#{deploy_to}/current/faye.ru"

namespace :faye do
	desc "start faye"
	task :start, :roles => :app do
		run "cd #{deploy_to}/current && bundle exec rackup #{faye_config} -s thin -E production -D --pid #{faye_pid}"
	end

	desc "stop faye"
	task :stop, :roles => :app do
		run "kill `cat #{faye_pid}` || true"
	end
end

before 'deploy:update_code', 'faye:stop'
after 'deploy:create_symlink', 'faye:start'

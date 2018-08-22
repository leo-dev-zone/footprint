
set :memcache_pid, "#{deploy_to}/shared/pids/memcache.pid"

namespace :memcache do
	desc "restart memcache"
	task :restart, :roles => :app do
		deploy.memcache.stop
		deploy.memcache.start
	end

	desc "start memcache"
	task :start, :roles => :app do
		run "cd #{deploy_to}/current && memcached -m 256 -p 11211 -P #{memcache_pid} -d"
	end

	desc "stop memcache"
	task :stop, :roles => :app do
		run "kill `cat #{memcache_pid}` || true"
	end
end

before 'deploy:update_code', 'memcache:stop'
after 'deploy:create_symlink', 'memcache:start'

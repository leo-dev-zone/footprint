
load 'config/deploy/unicorn'
load 'config/deploy/release'
#load 'config/deploy/faye'
#load 'config/deploy/memcache'
require 'bundler/capistrano'
require 'delayed/recipes'

namespace :deploy do

	desc "compile assets"
	task :compile_assets, :roles => :app do
		run "cd #{release_path} && bundle exec rake assets:precompile"
	end

	task :test_locale, :roles => :app do
		run "locale"
	end

	desc "deploy application"
	task :start, :roles => :app do
		unicorn.start
	end

	desc "initialize application for deployment"
	task :setup, :roles => :app do
		run "cd #{deploy_to} && mkdir -p releases shared shared/pids"
	end

	desc "clone repository"
	task :setup_code, :roles => :app do
		run "cd #{deploy_to} && git clone #{repository} cache"
	end

	desc "update VERSION"
	task :update_version, :roles => :app do
		run "cd #{deploy_to}/cache && git describe --abbrev=0 HEAD > ../current/VERSION && cat ../current/VERSION || true"
	end

	desc "dummy update_code task"
	task :update_code, :roles => :app do
	end

	desc "update codebase"
	task :pull_repo, :roles => :app do
		run "cd #{deploy_to}/cache && git pull"
	end

	desc "symlink dropbox folder"
	task :symlink_dropbox_folder, :roles => :app do
		run "cd #{release_path} && ln -s /home/deploy/Dropbox/DB_CLIENTS client_dropbox"
		run "cd #{release_path}/public && ln -s ../client_dropbox"
	end

	desc "symlink stylesheets-less"
	task :symlink_stylesheets_less, :roles => :app do
		run "cd #{release_path}/public && ln -s #{deploy_to}/shared/stylesheets-less/ stylesheets-less"
	end

	desc "make release directory"
	task :make_release_dir, :roles => :app do
		run "mkdir #{release_path}"
	end

	desc "copy code into release folder"
	task :copy_code_to_release, :roles => :app do
		run "cd #{deploy_to}/cache && cp -pR * #{release_path}/"
	end

	desc "run rake:db:migrate"
	task :migrate_db, :roles => :app do
		run "cd #{release_path} && RAILS_ENV=production NO_PERMS=1 bundle exec rake db:migrate"
	end

	desc "run rake roles:default_permissions"
	task :rake_perms, :roles => :app do
		run "cd #{release_path} && RAILS_ENV=production bundle exec rake roles:default_permissions"
	end

	desc "restart server"
	task :restart, :roles => :app do
		#run "cd #{deploy_to}/current && mongrel_rails cluster::restart"
		unicorn.restart
	end

	desc "make tmp directories"
	task :make_tmp_dirs, :roles => :app do
		run "cd #{deploy_to}/current && mkdir -p tmp/pids tmp/sockets"
	end

	desc "symlink pids directory"
	task :symlink_pids_dir, :roles => :app do
		run "cd #{release_path}/tmp && ln -s #{deploy_to}/shared/pids"
	end

	desc "create tmp/cache directory"
	task :create_cache_dir, :roles => :app do
		run "cd #{release_path}/tmp && mkdir -p cache"
	end

	desc "symlink database.yml"
	task :symlink_database_yml, :roles => :app do
		run "cd #{release_path}/config && ln -s #{deploy_to}/shared/database.yml database.yml"
	end

	desc "symlink initializers"
	task :symlink_initializers, :roles => :app do
		run "cd #{release_path}/config/initializers && ln -s #{deploy_to}/shared/config/initializers/site_keys.rb"
	end

	desc "symlink beeing"
	task :symlink_beeing, :roles => :app do
		run "cd #{release_path}/public && ln -s /var/www/beeing/rel/beeing/www chat"
	end

	task :finalize_update, :roles => :app do
	end
end

after 'deploy:setup', 'deploy:setup_code'
after 'deploy:pull_repo', 'deploy:copy_code_to_release'
before 'deploy:update_code', 'deploy:pull_repo'
after 'deploy:update_code', 'deploy:finalize_update'
before 'deploy:restart', 'deploy:create_cache_dir'
before 'deploy:restart', 'deploy:compile_assets'
before 'deploy:copy_code_to_release', 'deploy:make_release_dir'
before 'deploy:restart', 'deploy:migrate_db'
before 'deploy:symlink_database_yml', 'deploy:symlink_initializers'
after 'deploy:create_symlink', 'deploy:update_version'
after 'deploy:create_symlink', 'deploy:symlink_database_yml'

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

after 'deploy:create_symlink', 'deploy:make_tmp_dirs'

after 'deploy', 'deploy:cleanup'

require 'bundler/capistrano'

set :application, "classwatch"
set :repository,  "git://github.com/alwold/classwatch.git"
set :branch, 'production-20140801-patches'

set :scm, :git

set :deploy_to, "/home/alwold/classwatch"
set :use_sudo, false

role :web, "alwold.com"
role :app, "alwold.com"
role :db,  "alwold.com", :primary => true

before "deploy:assets:precompile", "deploy:symlink_db"

before "deploy:restart", "deploy:migrate"
after "deploy:restart", "deploy:restart_daemon"

namespace :deploy do
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   task :symlink_db, :roles => :app do
      run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{deploy_to}/shared/config/twilio.yml #{release_path}/config/twilio.yml"
      run "ln -nfs #{deploy_to}/shared/config/stripe.yml #{release_path}/config/stripe.yml"
   end
   task :restart_daemon, :roles => :app do
      migrate_env = fetch(:migrate_env, "production")
      run "cd #{release_path} && RAILS_ENV=#{migrate_env} bundle exec lib/daemons/classwatch_daemon_ctl stop"
      run "cd #{release_path} && RAILS_ENV=#{migrate_env} bundle exec lib/daemons/classwatch_daemon_ctl start"
   end
end

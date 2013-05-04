require 'bundler/capistrano'

set :application, "classwatch"
set :repository,  "git://github.com/alwold/classwatch.git"

#set :rails_env, :development
set :bundle_without, [:test]
#set :rake, "#{rake} --trace"

set :scm, :git

set :deploy_to, "/home/alwold/classwatch"
set :use_sudo, false

role :web, "alwold.com"                          # Your HTTP server, Apache/etc
role :app, "alwold.com"                          # This may be the same as your `Web` server
role :db,  "alwold.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

default_run_options[:pty] = true

#after "deploy:update_code","deploy:config_symlink"
before "deploy:assets:precompile", "deploy:symlink_db"

after "deploy:update", "deploy:restart"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   task :symlink_db, :roles => :app do
      run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{deploy_to}/shared/config/twilio.yml #{release_path}/config/twilio.yml"
      run "ln -nfs #{deploy_to}/shared/config/stripe.yml #{release_path}/config/stripe.yml"
   end
end

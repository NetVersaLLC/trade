require 'capistrano-db-tasks'
require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano-unicorn'

set :rvm_type, :user
set :db_local_clean, true

set :deploy_to, '/home/trade/app'
set :keep_releases, 5
set :default_shell, "bash -l"
set :rvm_ruby_string, 'ruby-2.0.0-p0'
set :rvm_type, :user

set :application, 'trade'
set :scm        , :git
set :repository , 'git@github.com:NetVersaLLC/trade.git'
set :user       , 'trade'
set :use_sudo   , false
set :ssh_options, {:forward_agent => true}

def production_prompt
  puts "\n\e[0;31m   ######################################################################"
  puts "   #\n   #       Are you REALLY sure you want to deploy to production?"
  puts "   #\n   #               Enter y/N + enter to continue\n   #"
  puts "   ######################################################################\e[0m\n"
  proceed = STDIN.gets[0..0] rescue nil
  exit unless proceed == 'y' || proceed == 'Y'
end

def staging_prompt
  puts "\n\e[0;31m   ######################################################################"
  puts "   #\n   #       Deploy to staging?     "
  puts "   ######################################################################\e[0m\n"
  proceed = STDIN.gets[0..0] rescue nil
  exit unless proceed == 'y' || proceed == 'Y'
end

desc 'Run tasks in new production enviroment.'
task :production do
  production_prompt
  set  :rails_env ,'production'
  set  :branch    ,'production'
  set  :host      ,'crowdgrip.com'
  role :app       ,host
  role :web       ,host
  role :db        ,host, :primary => true
end

task :staging do
  staging_prompt
  set  :rails_env ,'staging'
  set  :branch    ,'staging'
  set  :host      ,'staging.tradebitcoin.com'
  role :app       ,host
  role :web       ,host
  role :db        ,host, :primary => true
end


namespace :deploy do
  #desc 'Restarting server'
  #task :restart, :roles => :app, :except => { :no_release => true } do
    #run 'rvmsudo /etc/init.d/thin restart'
  #end

  #desc 'Stopping server'
  #task :stop, :roles => :app do
    #run 'rvmsudo /etc/init.d/thin stop'
  #end

  #desc 'Starting server'
  #task :start, :roles => :app do
    #run 'rvmsudo /etc/init.d/thin start'
  #end

  desc 'Running migrations'
  task :migrations, :roles => :db do
    run "cd #{release_path} && bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  end

  desc 'Building assets'
  task :assets do
    run "cd #{release_path} && bundle exec rake assets:precompile RAILS_ENV=#{rails_env}"
  end
end

namespace :nginx do
  desc 'Reload Nginx'
  task :reload do
    sudo '/etc/init.d/nginx reload'
  end
end

namespace :thin do
  desc 'Restart Thin'
  task :restart do
    run 'rvmsudo /etc/init.d/trade restart'
  end
end

task :after_update_code do
  %w{labels}.each do |share|
    run "ln -s #{shared_path}/#{share} #{release_path}/#{share}"
  end
  run "ln -s #{shared_path}/application.yml #{release_path}/config/application.yml"
  run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
end

after 'deploy'           , 'after_update_code'
after 'after_update_code', 'deploy:migrations'
after 'deploy:migrations', 'deploy:assets'
#after 'deploy:restart',   'unicorn:restart'  # app preloade

require './config/boot'

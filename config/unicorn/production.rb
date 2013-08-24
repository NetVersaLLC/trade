# http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/

worker_processes 3
app_path = "/home/trade/app/current"

working_directory app_path

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

# Spawn unicorn master worker for user apps (group: apps)
user 'trade', 'trade'

timeout 30

rails_env = ENV['RAILS_ENV'] || 'production'

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "/home/trade/app/shared/unicorn.sock", :backlog => 64

pid "/home/trade/app/current/tmp/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/home/trade/app/shared/log/unicorn-error.log"
stdout_path "/home/trade/app/shared/log/unicorn-out.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

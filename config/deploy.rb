# config valid only for Capistrano 3.4.0
lock '3.4.0'

set :application, 'triannon'
set :repo_url, 'https://github.com/sul-dlss/triannon-service.git'

# Prompt for the correct username
ask(:user, 'enter the app username')

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
ask(:home_parent_dir, %{Enter the full path of the parent of the home dir (e.g. /home)})
set :deploy_to, "#{File.join fetch(:home_parent_dir), fetch(:user), fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/triannon.yml config/environments/development.rb config/environments/production.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/cache tmp/pids tmp/rack-cache/meta tmp/rack-cache/body tmp/sockets vendor/bundle public/system config/environments}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

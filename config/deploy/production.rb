set :deploy_host, ask("Server", 'enter in the server you are deploying to. do not include .stanford.edu')
server "#{fetch(:deploy_host)}.stanford.edu", user: fetch(:user), roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, "staging"
Dir[File.dirname(__FILE__) + '/deploy/recipes/*.rb'].each {|file| require file }.each {|file| require file }

set :application, "startpoint"
set :repository,  "git@github.com:zquestz/startpoint.git"

# Set your version control system
set :scm, :git
set :git_enable_submodules, true

# Set up env
set :rails_env, 'production'
set :branch, 'master'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
default_run_options[:pty]   = true

# Only keep 5 releases
set :keep_releases, 5

# Define your servers
role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# Where are you deploying?
set :deploy_to, "/var/www/#{application}"

# Make sure you delete previous releases
# :keep_releases depends on this being present
after "deploy:update", "deploy:cleanup"
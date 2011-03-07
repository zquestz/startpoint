Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc "Restart the delayed_job process"
    task :delayed_job_restart, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec script/delayed_job restart"
    end
  end
end
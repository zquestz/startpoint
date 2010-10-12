Capistrano::Configuration.instance(:must_exist).load do
  # Passenger deployment restart
  namespace :deploy do
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
    end
  end
end
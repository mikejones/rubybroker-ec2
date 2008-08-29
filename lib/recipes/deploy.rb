Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
    
    desc "Start have been overwritten to restart apache"
    task :start, :roles => :app do
      run "apache2ctl graceful"
    end
    
    desc <<-DESC
      A slightly change version of the migrate script so it users MERB_ENV to migrate

        set :rake,           "rake"
        set :merb_env,      "production"
        set :migrate_env,    ""
        set :migrate_target, :latest
    DESC
    task :migrate, :roles => :db, :only => { :primary => true } do
      rake = fetch(:rake, "rake")
      merb_env = fetch(:merb_env, "production")
      migrate_env = fetch(:migrate_env, "")
      migrate_target = fetch(:migrate_target, :latest)

      directory = case migrate_target.to_sym
        when :current then current_path
        when :latest  then current_release
        else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
        end

      run "cd #{directory}; #{rake} MERB_ENV=#{merb_env} #{migrate_env} db:migrate"
    end
    
  end
end
Capistrano::Configuration.instance(:must_exist).load do
  namespace :passenger do
    desc "Analyze Phusion Passenger's and Apache's real memory usage."
    task :memory_stats, :roles => :app do
      run "passenger-memory-stats"
    end
    
    desc "Inspect Phusion Passenger's internal status"
    task :status, :roles => :app do
      run "passenger-status"
    end
    
  end
end


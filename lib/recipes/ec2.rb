Capistrano::Configuration.instance(:must_exist).load do
  namespace :instance do
    desc "Start an instance"
    task :start do
      system "ec2-run-instances #{image_id} -k #{keypair}"
    end
    
    task :describe do
      system "ec2-describe-instances #{instance_id}"
    end
  
    desc "Stop running instance"
    task :stop do
      system "ec2-terminate-instances #{instance_id}"
    end
  
    desc "SSH to running instance"
    task :ssh do
      system "ssh -i #{keypair_full_path} #{username}@#{instance_url}"
    end

    desc "Install and configure apache2 and passenger"
    task :bootstrap do
      install_apache
      install_passenger
      install_mysql
      install_git
      install_merb
      install_missing_gems
      setup_virtual_host
    end
    
    task :install_merb do
      if merb_version == "0.9.5"
        install_libxml
        install_memcacheclient
      end
      run "gem install merb -v #{merb_version} --no-ri --no-rdoc"
    end
    
    task :install_memcacheclient do
      run "gem install memcache-client --no-ri --no-rdoc"
    end
    
    task :install_libxml do
      run <<-CMD 
  apt-get install libxml2-dev -y &&
  gem install libxml-ruby --no-ri --no-rdoc
      CMD
    end
    
    task :install_missing_gems do
      run "gem install rubigen --no-ri --no-rdoc"
    end
  
    task :install_apache do
      run <<-CMD
  apt-get install apache2 -y &&
  apt-get install apache2-prefork-dev -y
      CMD
    end
  
    task :install_passenger do
      run <<-CMD
  gem install passenger --no-ri --no-rdoc &&
  cd /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3 &&
  rake clean apache2 &&
  echo "#phusion passenger" >> /etc/apache2/apache2.conf &&
  echo "LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3/ext/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf &&
  echo "PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-2.0.3" >> /etc/apache2/apache2.conf &&
  echo "PassengerRuby /usr/bin/ruby1.8" >> apache2.conf
      CMD
  # /etc/init.d/apache2 restart
    end
  
    task :install_mysql do
      run "apt-get install mysql-server -y"
    end
  
    task :install_git do
      run <<-CMD
  wget http://www.kernel.org/pub/software/scm/git/git-1.5.6.tar.gz &&
  tar -xzf git-1.5.6.tar.gz &&
  rm git-1.5.6.tar.gz &&
  cd git-1.5.6 &&
  ./configure &&
  make &&
  make install
      CMD
    end
  
    task :setup_virtual_host do
      run <<-CMD
      
  echo "127.0.0.1 localhost #{instance_url}" >> /etc/hosts &&
  echo "<VirtualHost *>" >> /etc/apache2/sites-available/#{application} &&
  echo "    ServerName #{instance_url}" >> /etc/apache2/sites-available/#{application} &&
  echo "    DocumentRoot #{deploy_to}/current/public" >> /etc/apache2/sites-available/#{application} &&
  echo "    ErrorLog #{deploy_to}/current/log/error.log" >> /etc/apache2/sites-available/#{application} &&
  echo "</VirtualHost>" >> /etc/apache2/sites-available/#{application} &&
  cd /etc/apache2/sites-available &&
  a2ensite #{application} 
      CMD
    end
  end
end
Capistrano::Configuration.instance(:must_exist).load do
  set :image_id, "ami-bded09d4"
  set :deploy_to, "/mnt/apps/#{application}"
  set :username, "root"
  set :use_sudo, false # because we are using debian etch

  set :keypair_full_path, "#{ENV['HOME']}/.ec2/id_rsa-#{keypair}"
  ssh_options[:username] = username
  ssh_options[:keys] = keypair_full_path
  default_run_options[:pty] = true
end
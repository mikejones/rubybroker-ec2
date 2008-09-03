Gem::Specification.new do |s|
  s.name = %q{rubybroker-ec2}
  s.version = "0.0.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Jones"]
  s.date = %q{2008-08-24}
  s.description = %q{Capistrano gumph for easy deployment of you merb app to ec2.}
  s.email = %q{michael.daniel.jones@gmail.com}
  s.files = ["lib/rubybroker-ec2.rb", "lib/recipes/settings.rb", "lib/recipes/ec2.rb", "lib/recipes/deploy.rb", "lib/recipes/passenger.rb"]
  s.homepage = %q{http://neophiliac.net/rubybroker-ec2}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Easy deployment for Merb applications.}
end


require File.expand_path('../lib/active_record/time_scope/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "activerecord-time-scope"
  gem.version     = ActiveRecord::TimeScope::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["Daisuke Taniwaki"]
  gem.email       = ["daisuketaniwaki@gmail.com"]
  gem.homepage    = "https://github.com/dtaniwaki/activerecord-time-scope"
  gem.summary     = "Time-Related Scope for ActiveRecord"
  gem.description = "Time-Related Scope for ActiveRecord"
  gem.license     = "MIT"

  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency "activerecord", ">= 3.2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 3.0"
  gem.add_development_dependency "coveralls"
end

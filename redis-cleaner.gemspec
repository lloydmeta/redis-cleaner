Gem::Specification.new do |gem|
    gem.name        = %q{redis-cleaner}
    gem.version = "0.0.1"
    gem.date = %q{2013-05-07}
    gem.authors     = ["Lloyd Meta"]
    gem.email       = ["lloydmeta@gmail.com"]
    gem.homepage    = "http://github.com/lloydmeta/redis-cleaner"
    gem.description = %q{A Ruby gem for cleaning up of Redis keys by pattern matching. Handles huge amounts of keys. Can be used with any Redis client that responds to #del and #keys}
    gem.summary     = gem.description

    gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    gem.files         = `git ls-files`.split("\n")
    gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gem.require_paths = ["lib"]

    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'webmock'
end
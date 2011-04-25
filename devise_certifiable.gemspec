# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_certifiable/version"

Gem::Specification.new do |s|
  s.name        = "devise_certifiable"
  s.version     = DeviseCertifiable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luis Gracia"]
  s.email       = ["lgraval@gmail.com"]
  s.homepage    = "https://github.com/luisico/devise_certifiable"
  s.summary     = %q{Sign up certification strategy for devise}
  s.description = %q{New sign ups need to be certified before they can sign in}

  s.add_dependency('rails',  '~> 3.0.0')
  s.add_dependency('devise', '~> 1.2.0')

  s.add_development_dependency('devise_invitable', '~> 0.4.0')
  s.add_development_dependency('bundler', '~> 1.0.12')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

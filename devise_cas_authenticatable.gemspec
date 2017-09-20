# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{devise_cas_authenticatable}
  s.version = "1.10.3"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nat Budin", "Jeremy Haile"]
  s.description = %q{CAS authentication module for Devise}
  s.license = "MIT"
  s.email = %q{natbudin@gmail.com}
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.homepage = %q{http://github.com/nbudin/devise_cas_authenticatable}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{CAS authentication module for Devise}

  s.add_runtime_dependency(%q<devise>, [">= 1.2.0"])
  s.add_runtime_dependency(%q<rubycas-client>, [">= 2.2.1"])

  s.add_development_dependency("rails", ">= 3.0.7")
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("test-unit", "~> 3.0")
  s.add_development_dependency("mocha")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("sham_rack")
  s.add_development_dependency("capybara")
  s.add_development_dependency('crypt-isaac')
  s.add_development_dependency('launchy')
  s.add_development_dependency('timecop')
  s.add_development_dependency('pry')
end

Gem::Specification.new do |s|
  s.name = 'devise_cas_authenticatable'
  s.version = '2.0.2'

  s.required_rubygems_version = Gem::Requirement.new('> 1.3.1') if s.respond_to? :required_rubygems_version=
  s.authors = ['Nat Budin', 'Jeremy Haile']
  s.description = 'CAS authentication module for Devise'
  s.license = 'MIT'
  s.email = 'natbudin@gmail.com'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = [
    'README.md'
  ]

  s.homepage = 'http://github.com/nbudin/devise_cas_authenticatable'
  s.require_paths = ['lib']
  s.rubygems_version = '1.5.0'
  s.summary = 'CAS authentication module for Devise'

  s.add_runtime_dependency('devise', ['>= 4.0.0'])
  s.add_runtime_dependency('rack-cas')

  s.add_development_dependency('capybara')
  s.add_development_dependency('database_cleaner-active_record')
  s.add_development_dependency('launchy')
  s.add_development_dependency('pry')
  s.add_development_dependency('rails')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('sqlite3')
end

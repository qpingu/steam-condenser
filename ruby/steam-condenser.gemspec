Gem::Specification.new do |s|
  s.name = 'steam-condenser'
  s.author = "Sebastian Staudt"
  s.email = "koraktor@gmail.com"
  s.summary = "Steam Condenser - A Steam query library"
  s.description = %{A multi-language library for querying the Steam Community, Source, GoldSrc servers and Steam master servers}
  s.homepage = "http://koraktor.github.com/steam-condenser"
  s.license = "BSD"
  
  s.version = '0.12.1'
  s.files = Dir['lib/**/*.rb']
  s.test_files = Dir['test/**/*_tests.rb']
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_path = 'lib'
  
  s.add_dependency('bzip2-ruby', '~> 0.2.7')
  s.add_dependency('json', '~> 1.5.1')
end

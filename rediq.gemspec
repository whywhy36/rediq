lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rediq/group/const'

Gem::Specification.new do |s|
  s.name          = 'rediq'
  s.version       = Rediq::VERSION
  s.summary       = "RediQ"
  s.description   = "RediQ is message queue and background job processor based on Redis"
  s.authors       = ["yuanzhuang", "yisuih"]
  s.email         = "whywhy36@gmail.com"
  s.homepage      = "https://github.com/whywhy36/rediq"

  s.add_dependency('redis')
  s.add_dependency('eventmachine')

  s.require_paths = ['lib']
  s.bindir        = 'bin'
  s.executables   = ['rediq-server', 'rediq-client']

  s.files         = %w[
    README.md
    rediq.gemspec
    bin/rediq-server
    bin/rediq-client
    lib/rediq/client.rb
    lib/rediq/group.rb
    lib/rediq/group/dispatcher.rb
    lib/rediq/group/worker.rb
    lib/rediq/group/script_runner.rb
    lib/rediq/group/const.rb
    lib/rediq/ext/redis_helper.rb
    lib/rediq/ext/env_checker.rb
    rediq.yml
  ]

end
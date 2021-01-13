Gem::Specification.new do |s|

  s.name     = 'such'
  s.version  = '1.0.210113'

  s.homepage = 'https://github.com/carlosjhr64/such'

  s.author   = 'carlosjhr64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2021-01-13'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Wraps widgets with an alternate constructor
which factors out the configuration and assembly procedures into metadata.
Can be used to wrap any class with the alternate constructor,
although currently only Gtk3 widgets is supported.
DESCRIPTION

  s.summary = <<SUMMARY
Wraps widgets with an alternate constructor
which factors out the configuration and assembly procedures into metadata.
Can be used to wrap any class with the alternate constructor,
although currently only Gtk3 widgets is supported.
SUMMARY

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options     = ['--main', 'README.rdoc']

  s.require_paths = ['lib']
  s.files = %w(
README.rdoc
lib/such.rb
lib/such/part.rb
lib/such/parts.rb
lib/such/such.rb
lib/such/thing.rb
lib/such/things.rb
  )

  s.requirements << 'ruby: ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]'

end

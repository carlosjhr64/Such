Gem::Specification.new do |s|

  s.name     = 'such'
  s.version  = '2.0.230106'

  s.homepage = 'https://github.com/carlosjhr64/such'

  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'

  s.date     = '2023-01-06'
  s.licenses = ['MIT']

  s.description = <<DESCRIPTION
Wraps widgets with an alternate constructor
which factors out the configuration and assembly procedures into metadata.
Can be used to wrap any class with the alternate constructor,
although targeted only Gtk3 widgets.
DESCRIPTION

  s.summary = <<SUMMARY
Wraps widgets with an alternate constructor
which factors out the configuration and assembly procedures into metadata.
Can be used to wrap any class with the alternate constructor,
although targeted only Gtk3 widgets.
SUMMARY

  s.require_paths = ['lib']
  s.files = %w(
README.md
lib/such.rb
lib/such/convention.rb
lib/such/part.rb
lib/such/parts.rb
lib/such/such.rb
lib/such/thing.rb
lib/such/things.rb
  )

  s.requirements << 'ruby: ruby 3.2.0 (2022-12-25 revision a528908271) [aarch64-linux]'

end

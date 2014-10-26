#!/usr/bin/env ruby

RUBY = 'ruby -I ./lib'
LOG = './test/errors.log'

def fn(name)
  "./test/tc_#{name}.rb"
end

def tc(name)
  system "#{RUBY} #{fn(name)} > #{LOG}"
end

if tc('version') and tc('thing') and tc('such') and tc('things')
  puts 'All tests passed!'
  File.unlink LOG
else
  puts "There were errors.  See #{LOG}"
  exit 1
end

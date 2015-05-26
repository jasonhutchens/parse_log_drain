require 'daemons'
require 'awesome_print'

script = File.join(File.expand_path(File.dirname(__FILE__)), 'drain.rb')
Daemons.run(script, { ARGV: ARGV + ["--", Dir.pwd] })

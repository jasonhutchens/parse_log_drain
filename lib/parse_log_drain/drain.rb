require 'fileutils'
require 'json'

parse_config = File.join(ARGV.first, 'config', 'global.json')
blob = File.read(parse_config)
apps = JSON.parse(blob)["applications"].keys - ["_default"]

log_dir = File.join(ARGV.first, "logs")
FileUtils.mkdir_p(log_dir)

threads =
  apps.map do |app|
    Thread.new do
      filename = app.downcase.gsub(/[^a-z0-9]/, '_') + ".log"
      log = File.join(log_dir, filename)
      loop do
        File.open(log, "a+") { |file| file.write("*** STARTING PARSE LOG DRAIN FOR '#{app}' ***\n") }
        `cd #{ARGV.first}; parse log --follow=true --level="INFO" "#{app}" >> #{log} 2>&1`
        File.open(log, "a+") { |file| file.write("*** EXITED WITH STATUS #{$?.exitstatus} ***\n") }
        sleep 30
      end
    end
  end
threads.each { |thread| thread.join }

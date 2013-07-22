lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'bundler/gem_tasks'

task :default => :test

desc "Run unit tests"
task :test do
  Dir[File.dirname(__FILE__) + '/test/**/*.rb'].each do |test_file|
    sh "ruby -I #{lib} #{test_file}"
  end
end

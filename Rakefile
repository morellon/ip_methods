$:.unshift(File.dirname(__FILE__) + "/lib")

require "rake"
require "spec/rake/spectask"
require "ip_methods/version"

begin
  require "hanna/rdoctask"
rescue LoadError => e
  require "rake/rdoctask"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ip_methods"
    gem.version = IpMethods::Version::STRING
    gem.summary = %Q{IpMethods gem for helping with IP operations}
    gem.description = %Q{Provides an easy way for dealing with IP operations!}
    gem.email = "morellon@gmail.com"
    gem.homepage = "http://github.com/morellon/ip_methods"
    gem.authors = ["morellon"]
    gem.add_development_dependency "rspec"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format specdoc --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Rspec : run all with RCov"
Spec::Rake::SpecTask.new('spec:rcov') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'gems', '--exclude', 'spec']
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.title = "IP Methods"
  rdoc.options += %w[ --line-numbers --inline-source --charset utf-8 ]
  rdoc.rdoc_files.include("README.rdoc", "CHANGELOG.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

task :default => :spec

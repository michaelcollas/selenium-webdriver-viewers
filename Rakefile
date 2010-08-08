require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "selenium-webdriver-viewers"
    gem.summary = 'Makes page objects and views for tests using selenium-webdriver.'
    gem.description = <<-END_DESCRIPTION
      This gem makes it easy to create page objects web viewers for use by tests that use selenium-webdriver. By
      using page and viewer objects, you can decouple your tests from the html details so that they can focus
      instead on describing the behaviour of your application. 
    END_DESCRIPTION
    gem.email = "mcollas@yahoo.com"
    gem.homepage = "http://github.com/michaelcollas/selenium-webdriver-viewers"
    gem.authors = ["Michael Collas"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "reek", ">= 1.2.8"
    gem.add_development_dependency "sexp_processor", ">= 3.0.4"
    gem.files.exclude('.gitignore')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
    t.ruby_opts << '-r' << 'rubygems' 
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "selenium-webdriver-viewers #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

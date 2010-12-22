# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{selenium-webdriver-viewers}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Collas"]
  s.date = %q{2010-12-23}
  s.description = %q{      This gem makes it easy to create page and web viewer objects for use by tests that use selenium-webdriver. By
      using page and viewer objects, you can decouple your tests from the html details so that they can focus
      instead on describing the behaviour of your application. 
}
  s.email = %q{mcollas@yahoo.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "VERSION",
    "lib/browser-instance.rb",
    "lib/element_reader.rb",
    "lib/element_value_reader.rb",
    "lib/element_value_writer.rb",
    "lib/page.rb",
    "lib/selenium-webdriver-viewers.rb",
    "lib/viewer.rb",
    "lib/webdriver-extensions.rb",
    "selenium-webdriver-viewers.gemspec",
    "spec/browser-instance_spec.rb",
    "spec/element_reader_spec.rb",
    "spec/element_value_reader_spec.rb",
    "spec/element_value_writer_spec.rb",
    "spec/page_spec.rb",
    "spec/selenium-webdriver-viewers_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/viewer_spec.rb"
  ]
  s.homepage = %q{http://github.com/michaelcollas/selenium-webdriver-viewers}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Makes page objects and views for tests using selenium-webdriver.}
  s.test_files = [
    "spec/browser-instance_spec.rb",
    "spec/element_reader_spec.rb",
    "spec/element_value_reader_spec.rb",
    "spec/element_value_writer_spec.rb",
    "spec/page_spec.rb",
    "spec/selenium-webdriver-viewers_spec.rb",
    "spec/spec_helper.rb",
    "spec/viewer_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<reek>, [">= 1.2.8"])
      s.add_development_dependency(%q<sexp_processor>, [">= 3.0.4"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<reek>, [">= 1.2.8"])
      s.add_dependency(%q<sexp_processor>, [">= 3.0.4"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<reek>, [">= 1.2.8"])
    s.add_dependency(%q<sexp_processor>, [">= 3.0.4"])
  end
end


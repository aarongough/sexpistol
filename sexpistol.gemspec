# coding: utf-8
Gem::Specification.new do |s|
  s.name = %q{sexpistol}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Gough"]
  s.date = %q{2010-10-15}
  s.description = %q{Sexpistol is an easy-to-use S-Expression parser for Ruby. It is fast and has no dependencies.}
  s.email = %q{aaron@aarongough.com}
  s.extra_rdoc_files = [
    "MIT-LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/sexpistol.rb",
     "lib/sexpistol/sexpistol.rb",
     "lib/sexpistol/sexpistol_parser.rb",
     "sexpistol.gemspec",
     "test/performance/benchmark_test.rb",
     "test/setup/test_unit_extensions.rb",
     "test/test_helper.rb",
     "test/unit/float_literal_test.rb",
     "test/unit/integer_literal_test.rb",
     "test/unit/ruby_keyword_literals_test.rb",
     "test/unit/scheme_compatability_test.rb",
     "test/unit/string_literal_test.rb",
     "test/unit/structure_test.rb",
     "test/unit/symbol_test.rb",
     "test/unit/to_sexp_test.rb"
  ]
  s.homepage = %q{http://github.com/aarongough/sexpistol}
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An S-Expression Parser Library for Ruby}
  s.test_files = [
    "test/performance/benchmark_test.rb",
     "test/setup/test_unit_extensions.rb",
     "test/test_helper.rb",
     "test/unit/float_literal_test.rb",
     "test/unit/integer_literal_test.rb",
     "test/unit/ruby_keyword_literals_test.rb",
     "test/unit/scheme_compatability_test.rb",
     "test/unit/string_literal_test.rb",
     "test/unit/structure_test.rb",
     "test/unit/symbol_test.rb",
     "test/unit/to_sexp_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


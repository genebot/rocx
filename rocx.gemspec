# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rocx/version'

Gem::Specification.new do |gem|
  gem.name          = "rocx"
  gem.version       = Rocx::VERSION
  gem.authors       = ["Gene Doyel"]
  gem.email         = ["gene.doyel@cph.org"]
  gem.description   = %q{Create Microsoft Word (.docx) files.}
  gem.summary       = %q{Using a simple API, create docx files programmatically, including bullet points, titles, headings, page breaks and tables!}
  gem.homepage      = "https://github.com/genebot/rocx"

  gem.add_dependency "nokogiri"
  gem.add_dependency "open_xml_package"
  
  gem.add_development_dependency "pry"
  gem.add_development_dependency "turn"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rr"
  gem.add_development_dependency "shoulda-context"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "timecop"
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = Dir.glob('spec/**/*_spec.rb')
  gem.require_paths = ["lib"]
end

Gem::Specification.new do |s|
  s.name = %q{mplayer-ruby}
  s.version = "0.1.0"
  s.required_rubygems_version = '1.3.6'
  s.authors = ["Arthur Chiu"]
  s.date = %q{2010-02-01}
  s.description = %q{A Ruby wrapper for MPlayer}
  s.email = %q{mr.arthur.chiu@gmail.com}
  s.extra_rdoc_files = Dir["*.rdoc"]
  s.files = ["LICENSE","README.rdoc","Rakefile","TODO"] + Dir.glob("{lib,test}/**/*")
  s.homepage = %q{http://github.com/achiu/mplayer-ruby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby wrapper for MPlayer}
  s.add_development_dependency(%q<riot>, [">= 0.10.11"])
  s.add_development_dependency(%q<rr>, [">= 0.10.5"])
  s.add_runtime_dependency(%q<open4>, [">= 1.0.1"])
end

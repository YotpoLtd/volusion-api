$:.push File.expand_path("../lib", __FILE__)
require "volusion"

Gem::Specification.new do |s|
  s.name     = "volusion"
  s.version  = Volusion::VERSION
  s.date     = Time.now.strftime("%Y-%m-%d")
  s.summary  = "Enables Ruby applications to communicate with the Volusion API"
  s.email    = "omri@yotpo.com"
  s.homepage = "https://github.com/YotpoLtd/volusion-api"
  s.description = "Enables Ruby applications to communicate with the Volustion API."
  s.has_rdoc = false
  s.authors  = ["Yotpo/omri@yotpo"]
  s.files = ["LICENSE", "Rakefile", "README.md", "volusion.gemspec"] + Dir['**/*.rb'] + Dir['**/*.crt']
  s.add_dependency 'multi_xml', '~> 0.5.1'
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "mocha"
end

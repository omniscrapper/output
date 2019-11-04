Gem::Specification.new do |s|
  s.name          = "omniscrapper_output"
  s.version       = "0.0.1"
  s.licenses      = ['MIT']
  s.summary       = "Output targets for omniscrapper"
  s.description   = "A collection of adapters, where omniscrapper is able to send scrapping results."
  s.author        = "Stanislav Mekhonoshin"
  s.email         = "ejabberd@gmail.com"
  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split($/)

  # TODO: set specific versions of those gems
  s.add_runtime_dependency 'waterdrop'
  s.add_runtime_dependency 'dry-struct'
end

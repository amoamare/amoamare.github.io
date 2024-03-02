# frozen_string_literal: true

Gem::Specification.new do |spec|
    spec.name          = "highlight_image_areas"
    spec.version       = "1.0.1"
    spec.authors       = ["Console Service Tool"]
    spec.email         = ["daattali@gmail.com"]
  
    spec.summary       = "Beautiful Jekyll is a ready-to-use Jekyll theme to help you create an awesome website quickly. Perfect for personal blogs or simple project websites, with a focus on responsive and clean design."
    spec.homepage      = "https://beautifuljekyll.com"
    spec.license       = "MIT"
  
    spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_plugins|LICENSE|README|feed|404|_data|tags|staticman)}i) }
  
    spec.add_runtime_dependency "jekyll", "~> 3.9.3"
  end
  
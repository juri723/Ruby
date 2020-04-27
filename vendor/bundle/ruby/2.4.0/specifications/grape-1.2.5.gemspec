# -*- encoding: utf-8 -*-
# stub: grape 1.2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "grape".freeze
  s.version = "1.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Bleigh".freeze]
  s.date = "2019-12-01"
  s.description = "A Ruby framework for rapid API development with great conventions.".freeze
  s.email = ["michael@intridea.com".freeze]
  s.homepage = "https://github.com/ruby-grape/grape".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A simple Ruby framework for building REST-like APIs.".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<builder>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<mustermann-grape>.freeze, ["~> 1.0.0"])
    s.add_runtime_dependency(%q<rack>.freeze, [">= 1.3.0"])
    s.add_runtime_dependency(%q<rack-accept>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<virtus>.freeze, [">= 1.0.0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<builder>.freeze, [">= 0"])
    s.add_dependency(%q<mustermann-grape>.freeze, ["~> 1.0.0"])
    s.add_dependency(%q<rack>.freeze, [">= 1.3.0"])
    s.add_dependency(%q<rack-accept>.freeze, [">= 0"])
    s.add_dependency(%q<virtus>.freeze, [">= 1.0.0"])
  end
end

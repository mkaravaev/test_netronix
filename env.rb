require 'bundler'
Bundler.require
Mongoid.load! File.expand_path("../mongoid.yml", __FILE__), :development


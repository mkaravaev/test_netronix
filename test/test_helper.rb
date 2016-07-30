require_relative "../env.rb"
require 'database_cleaner'

Bundler.require :test

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

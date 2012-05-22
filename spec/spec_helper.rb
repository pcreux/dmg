$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "rubygems"
require "bundler"
Bundler.load

require 'rspec'
require 'dmg'

Rspec.configure do |config|
  config.mock_with :rspec
end

ENV['DMG_HOME'] = File.join(File.dirname(__FILE__), '..', 'tmp', 'aruba')


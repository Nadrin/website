#!/usr/bin/env ruby
abort("TYPE environemnt variable required!") if ENV['TYPE'].nil?
abort("YML environment variable required!") if ENV['YML'].nil?

require 'set'
require 'yaml'
require 'pathname'

require 'rubygems'
require 'dimensions'

$type = ENV['TYPE']
$yml = YAML::load(File.open(ENV['YML']))

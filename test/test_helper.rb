require 'rubygems'
require 'test/unit'

require_files = []
require_files << File.join(File.dirname(__FILE__), '..', 'lib', 'sexpistol.rb')
require_files.concat Dir[File.join(File.dirname(__FILE__), 'setup', '*.rb')]

require_files.each do |file|
  require File.expand_path(file)
end
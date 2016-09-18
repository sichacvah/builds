$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))


require 'git'
require 'open-uri'
require 'fileutils'
require "mini_magick"
require 'tmpdir'

require 'carmen_builds/config'
require 'carmen_builds/builders'

Dir[File.expand_path('../config/initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))


require 'git'
require 'open-uri'
require 'fileutils'
require "mini_magick"
require 'tmpdir'
require 'dotenv'

Dotenv.load

require 'carmen_builds/config'
require 'carmen_builds/builders'



Dir[File.expand_path('../config/initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

module CarmenBuilds
  def self.build
    CarmenBuilds::Builders.platforms << CarmenBuilds::Builders::Android::AndroidBuilder.new
    CarmenBuilds::Builders.build config
  end

  def self.config
    CarmenBuilds::Config.new do |config|
      config.repo_url = 'git@techinform.pro:carmen_client_app'
      config.project_name = 'carmen_client_app'
      config.application_id = 'ru.car4men.app.client'
      config.icon_url = 'http://www.car4men.ru/images/app_logo_big.png'
    end
  end
end

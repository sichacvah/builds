$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
STDOUT.sync = true


require 'git'
require 'open-uri'
require 'fileutils'
require "mini_magick"
require 'tmpdir'
require 'dotenv'
require 'open3'

Dotenv.load

require 'carmen_builds/config'
require 'carmen_builds/builders'
require 'android_configs'

Dir[File.expand_path('../config/initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

module CarmenBuilds
  def self.build
    CarmenBuilds::Builders.platforms = self.platforms
    self.configs.each do |config|
      CarmenBuilds::Builders.build config
    end
  end

  def self.configs
    @configs ||= [self.workstation_config]
  end

  def self.client_config
    CarmenBuilds::Config.new do |config|
      config.repo_url = 'git@techinform.pro:carmen_client_app'
      config.project_name = 'carmen_client'
      config.application_id = 'ru.car4men.app.client'
      config.icon_url = File.expand_path 'android_icons/client.png'
      config.store_name = 'Кармен'
      config.node_modules = '../node_modules'
    end
  end

  def self.workstation_config
    CarmenBuilds::Config.new do |config|
      config.repo_url = 'git@techinform.pro:carmen_manager_app'
      config.project_name = 'carmen_arm'
      config.application_id = 'ru.car4men.app.workstation'
      config.icon_url = File.expand_path 'android_icons/client.png'
      config.store_name = 'Кармен АРМ'
    end
  end

  def self.platforms=(pfrms = [])
    @platforms = pfrms
  end

  def self.platforms
    @platforms ||= [
      #CarmenBuilds::Builders::Android::AndroidBuilder.new,
      CarmenBuilds::Builders::IOS::IOSBuilder.new
    ]
  end

  def self.configure(cfgs = [])
    cfgs.each do |config|
      self.configs << self.parse_config(config)
    end
  end

  def self.parse_config(config)
    case config
    when CarmenBuilds::Config then config
    when Hash then CarmenBuilds::Config.new config
    else
      throw ArgumentError, config
    end
  end
end

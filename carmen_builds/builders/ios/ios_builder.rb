require 'json'
module CarmenBuilds
  module Builders
    module IOS
      class IOSBuilder < Builder
        ICON_SIZES = {
          icon_small: '29x29',
          icon_small_2x: '58x58',
          icon: '57x57',
          icon_2x: '114x114',
          icon_40: '40x40',
          icon_40_2x: '80x80',
          icon_50: '50x50',
          icon_50_2x: '100x100',
          icon_60: '60x60',
          icon_60_2x: '120x120',
          icon_60_3x: '180x180',
          icon_72: '72x72',
          icon_72_2x: '144x144',
          icon_76: '76x76',
          icon_76_2x: '152x152'
        }

        SCREEN_SIZES = {
          'screen-ipad-portrait' => '768x1280',
          'screen-ipad-portrait-2x' => '1536x2048',
          'screen-iphone-portrait' => '320x480',
          'screen-iphone-portrait-2x' => '640x960',
          'screen-iphone-portrait-568h-2x' => '640x1136',
          'screen-iphone-portrait-667h' => '750x1334',
          'screen-iphone-portrait-736h' => '1242x2208'
        }

        build do |config|
          self.prepare_icons config
          self.prepare_screens config
          self.prepare_fastlane config
          self.run_fastlane config
          self.npm_install config
        end


        class << self
          def prepare_fastlane(config)
            fastlane = CarmenBuilds::Builders::FastlaneRender.new(config)
            fastlane.prepare({
              templates: File.expand_path('templates/fastlane/ios'),
              destinition: 'ios/fastlane'
            })
          end

          def self.npm_install(config)
            self.run_cmd('npm i', {chdir: config.git.dir.path})
          end

          def run_fastlane config
            self.run_cmd("fastlane appstore", chdir: "#{config.git.dir.path}/ios")
          end


          def contents_json(sizes)
            contents_obj = {
              'images' => [],
              'info' => {
                'version' => 1,
                'author' => 'xcode'
              }
            }
            sizes.map do |key,val|
              contents_obj['images'] << {
                size: val,
                idiom: self.idiom(key),
                filename: key,
                scale: self.scale(key)
              }
            end
            JSON.pretty_generate contents_obj
          end

          def idiom(key)
            if key.to_s =~ /ipad/
              'ipad'
            else
              'iphone'
            end
          end

          def scale(key)
            case key.to_s[-2..-1]
            when '2x' then '2x'
            when '3x' then '3x'
            else
              '1x'
            end
          end

          def create_screen_backgroung(size)
            image_path = self.tmp_bg_path(size)
            `convert -size #{size} canvas:'#EFEFEF' #{image_path}`
            image_path
          end

          def tmp_bg_path(size)
            File.join File.expand_path('tmp'), "screen-#{size}.png"
          end

          def delete_screen_bg(size)
            File.delete(self.tmp_bg_path(size)) if File.exist?(self.tmp_bg_path(size))
          end

          def icons_res_path(config)
            File.join FileUtils::mkdir_p(File.join(config.git.dir.path, "ios/#{config.project_name}/Images.xcassets/AppIcon.appiconset"))
          end

          def screens_res_path(config)
            File.join FileUtils::mkdir_p(File.join(config.git.dir.path, "ios/#{config.project_name}/Images.xcassets/LaunchImage.launchimage"))
          end

          def prepare_icons(config)
            path = self.icons_res_path(config)
            IOSBuilder::ICON_SIZES.each do |key, value|
              image = MiniMagick::Image.open(config.icon_url)
              image.resize value
              image.write File.join(path, key.to_s + '.png')
            end
            self.create_contents(path, self.contents_json(ICON_SIZES))
          end

          def create_contents(path, json)
            File.open(File.join(path, 'Contents.json'), 'w+') do |f|
              f.write json
            end
          end

          def prepare_screens(config)
            path = self.screens_res_path(config)
            IOSBuilder::SCREEN_SIZES.each do |name, size|
              bg_image = MiniMagick::Image.new(create_screen_backgroung(size))
              icon = MiniMagick::Image.open(config.icon_url)
              width = size.split('x').first.to_i / 3
              icon.resize "#{width}x#{width}"
              result = bg_image.composite(icon, 'png') do |i|
                i.compose "Over"
                i.gravity 'center'
              end
              result.write File.join(path, "#{name}.png")
              self.delete_screen_bg(size)
            end
            self.create_contents(path, self.contents_json(SCREEN_SIZES))
          end


        end
      end
    end
  end
end

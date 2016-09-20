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

        RES_PATH = 'android/app/src/main/res'

        build do |config|
          self.prepare_icons config
        end

        class << self
          def icons_json
            icons_obj = {
              'images' => [],
              'info' => {
                'version' => 1,
                'author' => 'xcode'
              }
            }
            ICON_SIZES.map do |key,val|
              icons_obj[images] << {
                size: val,
                idiom: 'iphone',
                filename: key,
                scale: self.scale(key)
              }
            end
            icons_obj.to_json
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
            `convert -size #{size} canvas:'#EFEFEF' #{self.tmp_background_path(size)}`
          end

          def tmp_screen_path(size)
            File.join File.expand_path('tmp') "screen-#{size}.png"
          end


          def delete_screen(size)
            File.delete(self.tmp_background_path(size)) if File.exist?(self.tmp_background_path(size))
          end

          def icons_res_path(config)
            FileUtils.mkdir_p "ios/#{config.project_name}/Images.xcassets/AppIcon.appiconset"
          end

          def screens_res_path(config)
            FileUtils.mkdir_p "ios/#{config.project_name}/Images.xcassets/LaunchImage.launchimage"
          end



          def prepare_icons(config)
            IOSBuilder::ICON_SIZES.each do |key, value|
              path = FileUtils::mkdir_p File.join(config.git.dir.path, self.screens_res_path(config), "drawable-#{key}")
              image = MiniMagick::Image.open(config.icon_url)
              image.resize value
              image.write File.join(path, key.to_s + '.png')
            end
          end

        end
      end
    end
  end
end

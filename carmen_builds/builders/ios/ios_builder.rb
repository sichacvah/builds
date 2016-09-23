require 'json'
module CarmenBuilds
  module Builders
    module IOS
      class IOSBuilder < Builder
        ICON_SIZES = {
          'icon_small@2x' => {
            size:  29,
            scale: 2,
          },
          'icon_small@3x' => {
            size: 29,
            scale: 3,
          },
          'icon_40@2x' => {
            size: 40,
            scale: 2
          },
          'icon_40@3x' => {
            size: 40,
            scale: 3
          },
          'icon_60@2x' => {
            size: 60,
            scale: 2
          },
          'icon_60@3x' => {
            size: 60,
            scale: 3
          }
        }

        SCREEN_SIZES = {
          'Default-736h' => {
            size: '1242x2208',
            scale: 3,
          },
          'Default-667h' => {
            size: '750x1334',
            scale: 2,
          },
          'Default@2x~iphone' => {
            size: '640x960',
            scale: 2,
          },
          'Default-568h@2x~iphone' => {
            scale: 2,
            size: '640x1136',
          },
          'Default~iphone' => {
            scale: 1,
            size: '320x480'
          }
        }

        build do |config|
          self.prepare_icons config
          self.prepare_screens config
          self.prepare_fastlane config
          self.npm_install config
          self.run_fastlane config
        end


        class << self
          def prepare_fastlane(config)
            fastlane = CarmenBuilds::Builders::FastlaneRender.new(config)
            fastlane.prepare({
              templates: File.expand_path('templates/fastlane/ios'),
              destinition: 'ios/fastlane'
            })
          end

          def npm_install(config)
            self.run_cmd('npm i', {chdir: config.git.dir.path})
          end

          def run_fastlane config
            self.run_cmd("fastlane release", chdir: "#{config.git.dir.path}/ios")
          end


          def contents_json(sizes)
            contents_obj = {
              'images' => [],
              'info' => {
                'version' => 1,
                'author' => 'xcode'
              }
            }
            sizes.map do |name, params|
              size = params[:size]
              scale = params[:scale]
              contents_obj['images'] << {
                size: "#{size}x#{size}",
                idiom: 'iphone',
                filename: "#{name}.png",
                scale: "#{scale}x"
              }
            end
            JSON.pretty_generate contents_obj
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
            IOSBuilder::ICON_SIZES.each do |key, params|
              size = params[:size]*params[:scale]
              image = MiniMagick::Image.open(config.icon_url)
              image.resize "#{size}x#{size}"
              image.write File.join(path, key + '.png')
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
          end
        end
      end
    end
  end
end

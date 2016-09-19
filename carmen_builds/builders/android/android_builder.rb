module CarmenBuilds
  module Builders
    module Android
      class AndroidBuilder < Builder
        ICON_SIZES = {
          ldpi: '36x36',
          mdpi: '48x48',
          hdpi: '72x72',
          xhdpi: '96x96',
          xxhdpi: '144x144',
          xxxhdpi: '192x192',
        }

        RES_PATH = 'android/app/src/main/res'

        build do |config|
          prepare_icons config
          prepare_gradle config
          prepare_fastlane config
        end

        def prepare_icons(config)
          AndroidBuilder::ICON_SIZES.each do |key, value|
            path = FileUtils::mkdir_p File.join(config.git.dir.path, AndroidBuilder::RES_PATH, "drawable-#{key}")
            image = MiniMagick::Image.open(config.icon_url)
            image.resize value
            image.write File.join(path, 'ic_launcher.png')
          end
        end

        def prepare_gradle(config)
          gradle = GradleUpdater.new(config)
          gradle.prepare
        end

        def prepare_fastlane(config)
          fastlane = FastlaneRender.new(config)
          fastlane.prepare
        end

        def build_fast_lane
          `fastlane supply init`
          `fastlane playstore`
        end


      end
    end
  end
end

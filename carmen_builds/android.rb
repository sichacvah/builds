module CarmenBuilds
  module Builders
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
        run_fastlane config        
      end

      def prepare_icons(config)
        AndroidBuilder::ICON_SIZES.each do |key, value|
          path = FileUtils::mkdir_p File.join(config.git.dir.path, AndroidBuilder::RES_PATH, "drawable-#{key}")
          image = MiniMagick::Image.open(config.icon_url)
          image.resize value
          image.write File.join(path, 'ic_launcher.png')
        end
      end
    end
  end
end

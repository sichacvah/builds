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
          self.prepare_icons config
          self.prepare_gradle config
          self.prepare_fastlane config
          self.npm_install config
          self.init_fastlane config
          self.build_fastlane config
        end

        def self.prepare_icons(config)
          AndroidBuilder::ICON_SIZES.each do |key, value|
            path = FileUtils::mkdir_p File.join(config.git.dir.path, AndroidBuilder::RES_PATH, "drawable-#{key}")
            image = MiniMagick::Image.open(config.icon_url)
            image.resize value
            image.write File.join(path, 'ic_launcher.png')
          end
        end

        def self.prepare_gradle(config)
          gradle = Gradle.new(config)
          gradle.prepare
        end

        def self.prepare_fastlane(config)
          fastlane = CarmenBuilds::Builders::FastlaneRender.new(config)
          fastlane.prepare({
            templates: File.expand_path('templates/fastlane/android'),
            destinition: 'android/fastlane'
          })
        end

        def self.run_cmd(cmd, options={})
          STDOUT.flush
          Open3.popen3(cmd, options) do |stdin, stdout, stderr, wait_thr|
            while line = stdout.gets
              STDOUT.puts line
            end
            STDERR.puts stderr.read
          end
        end

        def self.npm_install(config)
          self.run_cmd('npm i', {chdir: config.git.dir.path})
        end

        def self.init_fastlane(config)
          self.run_cmd("fastlane supply init", chdir: "#{config.git.dir.path}/android")
        end

        def self.build_fastlane(config)
          self.run_cmd("fastlane playstore", chdir: "#{config.git.dir.path}/android")
        end
      end

    end
  end
end

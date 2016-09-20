module CarmenBuilds
  module Builders
    module Android
      class FastlaneRender
        include ERB::Util
        TEMPLATES_PATH = File.expand_path('templates/fastlane')
        attr_accessor :json_key_file, :package_name, :git

        def initialize(config)
          @json_key_file = File.join(ENV['JSON_KEY_FILE'])
          @package_name = config.project_name
          @git = config.git
        end

        def templates
          @templates ||= get_templates
        end

        def render(template)
          ERB.new(template).result(binding)
        end

        def prepare
          Dir.glob(TEMPLATES_PATH.to_s + '/*.erb').each do |template|
            save template, file_path(template)
          end
        end

        def save(template, file)
          File.open(file, 'w+') do |f|
            f.write render(template)
          end
        end

        private

        def file_path template
          File.join fastlane_path, base_name(template)
        end

        def fastlane_path
          FileUtils.mkdir_p File.join(git_path, 'fastlane')
        end

        def git_path
          @git_path ||= @git.dir.path
        end

        def base_name(template)
          File.basename(template, '.erb')
        end
      end
    end
  end
end

module CarmenBuilds
  module Builders
    module Android
      class FastlaneRender
        include ERB::Util
        TEMPLATES_PATH = File.expand_path('../../../teplates/fastlane', __FILE__)
        attr_accessor :json_key_file, :package_name, :git

        def initialize(config)
          @json_key_file = ENV['JSON_KEY_FILE']
          @package_name = config.project_name
          @git = config.git
        end

        def templates
          @templates ||= get_templates
        end

        def render()
          ERB.new(template).result(binding)
        end

        def prepare
          templates.each do |template|
            save template, file_path(template)
          end
        end

        def save(template, file)
          File.open(file, 'w+') do |file|
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
          File.base_name(template, '.erb')
        end

        def get_templates
          templates = []
          Dir.glob(TEMPLATES_PATH +  '/*.erb') do |template|
            templates << template.read
          end
          templates
        end
      end
    end
  end
end

module CarmenBuilds
  module Builders
    class FastlaneRender
      include ERB::Util
      attr_accessor :json_key_file, :package_name, :git

      def initialize(config)
        @json_key_file = File.expand_path(ENV['JSON_KEY_FILE'])
        @config = config
      end

      def templates
        @templates ||= get_templates
      end

      def render(template_path)
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end

      def prepare(options = {})
        Dir.glob(options[:templates].to_s + '/*.erb').each do |template|
          save template, file_path(template, options[:destinition])
        end
      end

      def save(template, file)
        File.open(file, 'w+') do |f|
          f.write render(template)
        end
      end

      private

      def file_path(template, destinition)
        File.join fastlane_path(destinition), base_name(template)
      end

      def fastlane_path(destinition)
        FileUtils.mkdir_p File.join(git_path, destinition)
      end

      def git_path
        @git_path ||= @config.git.dir.path
      end

      def base_name(template)
        File.basename(template, '.erb')
      end
    end
  end
end

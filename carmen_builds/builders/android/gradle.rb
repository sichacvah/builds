module CarmenBuilds
  module Builders
    class Gradle
      def initialize(config)
        @config = config
      end

      def path
        @path ||= File.expand_path(@config.git.dir.path, 'android/app/build.gradle')
      end

      def file
        @file ||= File.read(path)
      end

      def set_application_id!
        file.gsub!(/(?<=applicationId )(\".+\")/, "\"#{@config.application_id}\"")
      end

      def set_version_code!
        file.gsub!(/(?<=versionCode )(\d+)/, "#{$1.to_i + 1}")
      end

      def set_version_name!
        file.gsub!(/(?<=versionName )(\d+)/, "\"#{increment_patch_ver($1)}\"")
      end

      def save!
        File.open(path, 'w') do |file|
          file.puts(@file)
        end
      end

      def increment_patch_ver(version_str)
        ver = version_str.gsub(/"/, "").split "."
        case ver.length
        when 1 then "#{ver.first}.0.1"
        when 2 then "#{ver[0]}.#{ver[1]}.1"
        when 3 then "#{ver[0]}.#{ver[1]}.#{ver[2].to_i + 1}"
        else "0.0.1"
        end
      end

      def prepare
        set_application_id!
        set_version_code!
        set_version_name!
        save!
      end

    end
  end
end

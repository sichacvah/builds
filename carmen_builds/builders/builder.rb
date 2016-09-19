module CarmenBuilds
  module Builders
    def self.build(config)
      platforms.each { |platform| platform.build(config) }
    end

    def self.platforms
      @platforms ||= []
    end

    class Builder
      class << self
        def build(&block)
          define_method :build do |config|
            self.class.clone_repo(config)
            block.call(config)
          end
        end

        def tmpdir
          @tmpdir ||= Dir.mktmpdir(nil, tmp_path)
        end

        def tmp_path
          @tmp_path ||= File.expand_path('tmp')
        end

        def clone_repo(config)
          config.git ||= Git.clone(config.repo_url, config.project_name, path: tmpdir)
        end
      end
    end

  end
end

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
          define_method :buld do |config|
            clone_repo(config)
            block.call(config)
          end
        end

        def tmpdir
          @tmpdir ||= Dir.mktmpdir(nil, tmp_path)
        end

        def tmp_path
          @tmp_path ||= File.expand_path('../../tmp', __FILE__)
        end

        def clone_repo(config)
          config.git = Git.clone(config.repo_url, config.project_name, tmpdir)
        end
      end
    end

  end
end

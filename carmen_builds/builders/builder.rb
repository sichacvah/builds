module CarmenBuilds
  module Builders

    def self.build(config)
      platforms.each { |platform| platform.build(config) }
    end

    def self.platforms
      @platforms ||= []
    end

    def self.platforms=(p =[])
      @platforms = p
    end

    def self.erase_platforms
      @platforms = []
    end

    class Builder
      class << self
        def build(&block)
          define_method :build do |config|
            self.class.clone_repo(config)
            self.class.prepare_in_app_icon(config)
            self.class.set_env_id(config) unless config.id.nil?
            self.class.set_color(config) unless config.color.nil?
            block.call(config)
          end
        end


        def set_env_id(config)
          path = File.join(config.git.dir.path, 'js', 'env.js')
          file = File.read(path)
          file.gsub!(/jsonApiEndpoint:\s+'api\/mobile\/(\d)\/'/) do |match|
            "jsonApiEndpoint: 'api/mobile/#{config.id}/'"
          end
          File.open(path, 'w+') {|f| f.write(file)}
        end

        def prepare_in_app_icon(config)
          image = MiniMagick::Image.open(config.icon_url)
          image.write File.join(config.git.dir.path, 'js', 'img', 'app.png')
        end

        def set_color(config)
          path = File.join(config.git.dir.path, 'js', 'common', 'CommonColors.js')
          file = File.read(path)
          file.gsub!(/(?<=appColor: ')(#\w+)(?=')/) do |match|
            config.color
          end
          File.open(path, 'w+') {|f| f.write(file)}
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

        def run_cmd(cmd, options={})
          STDOUT.flush
          Open3.popen3(cmd, options) do |stdin, stdout, stderr, wait_thr|
            while line = stdout.gets
              STDOUT.puts line
            end
            STDERR.puts stderr.read
          end
        end
      end
    end

  end
end

module CarmenBuilds
  class Builder
    attr_accessor :git_repo, :original_icon_url
    attr_reader :tmpdir

    def initialize(options = {})
      options.each do |key, val|
        instance_variable_set("@#{key}", val)
      end

      yield(self) if block_given?
    end

    def build
      raise NoMethodError, 'Not implement'
    end

    def clone_and_build
      clone_repo
      build
    end

    protected

    def clone_repo
      init_tmp_dir
      puts "[#{Time.now.strftime('%H:%M%S')}] Start Cloning #{@git_repo}"
      @git =  Git.clone(@git_repo,'tmp', path: @tmddir)
      puts "[#{Time.now.strftime('%H:%M%S')}] End Cloning #{@git_repo}"
      #@git = `git clone #{@git_repo, @tmddir + "/client"}`.chomp
    end

    def init_tmp_dir
      path = File.expand_path('../../tmp', __FILE__)
      Dir.mktmpdir(nil, path) do |dir|
        @tmddir = dir
      end
    end
  end
end

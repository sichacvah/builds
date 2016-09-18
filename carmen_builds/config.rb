module CarmenBuilds
  class Config
    attr_accessor :repo_url, :project_name, :platform, :type, :application_id, :git
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end
  end
end

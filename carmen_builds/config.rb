module CarmenBuilds
  class Config
    attr_accessor :repo_url, :project_name, :application_id, :git, :icon_url, :store_name, :id, :color
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end
  end
end

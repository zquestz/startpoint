class Setting
  
  # Access all settings through the method missing
  def self.method_missing(method, *args)
    begin
      super(method, *args)
    rescue
      app_settings[method.to_s]
    end
  end
  
  # Get application settings from default YAML file and merge with 
  # environment YAML file.
  def self.app_settings
    unless Thread.current[:settings]
      config = read_settings
      default_settings = config['default'] || {}
      env_settings = config[Rails.env] || {}
      Thread.current[:settings] = default_settings.recursive_merge(env_settings)
    end
    return Thread.current[:settings]
  end

  # YAML file loader
  def self.read_settings
    YAML.load(File.read(RAILS_ROOT + '/config/settings.yml'))
  end
  
end
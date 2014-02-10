RailsConfig.setup do |config|
  config.const_name = "Settings"
end
SEN_SETTINGS = YAML.load_file("#{::Rails.root}/config/sensitive_settings.yml")
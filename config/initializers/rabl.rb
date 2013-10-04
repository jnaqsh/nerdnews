require 'rabl'
Rabl.configure do |config|
  config.include_json_root = false
  config.enable_json_callbacks = true
end

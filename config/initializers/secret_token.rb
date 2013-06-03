# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

app_config = YAML.load(File.read(Rails.root.join('config', 'application_configs.yml')))

Nerdnews::Application.config.secret_token = app_config["secret_token"]

require 'omniauth/openid'
require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'bAtULeEoYc5pagNLrVSj5w', 'PRhYevhq4Q9nt0YcnQzexbi4BrypxjTn4zgfB5Cp0'
  provider :facebook, '8666faeace263ad196e86ae916e1bdbb', '190c8aecfacbb7da341f51e04f9e6233', :scope => 'publish_stream'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'

  provider :google_apps, OpenID::Store::Filesystem.new('/tmp')
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end

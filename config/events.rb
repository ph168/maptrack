WebsocketRails::EventMap.describe do
  subscribe :client_connected, to: ChannelController, with_method: :client_connected

  namespace :websocket_rails do
    subscribe :subscribe_private, :to => ChannelController, :with_method => :authorize_channels
  end
end

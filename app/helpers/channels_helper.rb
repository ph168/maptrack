module ChannelsHelper
  def channel_for(user)
    WebsocketRails[(user.token + "_notifications").to_sym]
  end
end

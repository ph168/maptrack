class ChannelController < WebsocketRails::BaseController
  def client_connected
  end

  def authorize_channels
    if message[:channel].to_s.include? current_user.email
      accept_channel message
    else
      deny_channel "not allowed to join"
    end
  end
end

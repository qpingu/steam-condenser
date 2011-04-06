# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2008-2010, Sebastian Staudt

require 'steam/servers/game_server'
require 'steam/sockets/goldsrc_socket'

class GoldSrcServer
  include GameServer
  
  attr_reader :hltv

  # Should reorder arguments
  def initialize(remote_host, remote_port = 27015, local_host = nil, local_port = nil, is_hltv = false)
    super remote_host, remote_port, local_host, local_port
    @hltv = is_hltv
    
    @socket = GoldSrcSocket.new host, port, local_host, local_port, hltv
    @socket.connect
  end

  def rcon_auth(password)
    @rcon_password = password
    true
  end

  def rcon_exec(command)
    @socket.rcon_exec(@rcon_password, command).strip
  end
end

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
  def initialize(remote_host, remote_port = 27015, is_hltv = false)
    super remote_host, remote_port
    @hltv = is_hltv
    
    @socket = GoldSrcSocket.new host, port, hltv
  end
  
  def rcon_auth(password)
    @rcon_password = password
    true
  end

  def rcon_exec(command)
    @socket.rcon_exec(@rcon_password, command).strip
  end
  
  # Splits the player status obtained with +rcon status+
  def self.split_player_status(player_status)
    player_data = player_status.match(/# *(\d+) +"(.*)" +(\d+) +(.*)/).to_a[1..-1]
    player_data[3] = player_data[3].split
    player_data.flatten!
    player_data[0] = player_data[2]
    player_data.delete_at(2)
    player_data.delete_at(4)
    player_data
  end
end

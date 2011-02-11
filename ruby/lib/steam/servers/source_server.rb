# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2008-2011, Sebastian Staudt

require 'exceptions/rcon_no_auth_exception'
require 'exceptions/rcon_no_connection_exception'
require 'steam/packets/rcon/rcon_auth_request'
require 'steam/packets/rcon/rcon_auth_response'
require 'steam/packets/rcon/rcon_exec_request'
require 'steam/servers/game_server'
require 'steam/sockets/rcon_socket'
require 'steam/sockets/source_socket'

class SourceServer
  include GameServer

  attr_reader :local_host, :local_port

  def initialize(remote_host, remote_port = 27015, local_host = nil, local_port = nil)
    super remote_host, remote_port
    @local_host, @local_port = local_host, local_port
    
    @socket = SourceSocket.new host, port
  end
  
  def rcon_connect(password = nil)
    @rcon_socket = RCONSocket.new host, port, local_host, local_port
    rcon_auth(password) if password
    true
  end
  
  def rcon_disconnect
    @rcon_socket.close if @rcon_socket
    @rcon_socket = nil
  end

  def rcon_auth(password)
    rcon_connect unless @rcon_socket # for compability with older versions
    
    @rcon_request_id = rand 2**16

    @rcon_socket.send RCONAuthRequest.new(@rcon_request_id, password)
    @rcon_socket.reply
    reply = @rcon_socket.reply

    raise RCONNoAuthException.new if reply.request_id == -1

    reply.request_id == @rcon_request_id
  end

  def rcon_exec(command)
    raise RCONNoConnectionException.new unless @rcon_socket
    
    @rcon_socket.send RCONExecRequest.new(@rcon_request_id, command)
    @rcon_socket.send RCONExecRequest.new(@rcon_request_id, nil)
    response_packets = []

    begin
      response_packet = @rcon_socket.reply
      raise RCONNoAuthException.new if response_packet.is_a? RCONAuthResponse
      response_packets << response_packet
    end while response_packet.response.size > 0

    response = ''
    response_packets.each do |packet|
      response << packet.response
    end

    response.strip
  end
  
  # Splits the player status obtained with +rcon status+
  def self.split_player_status(player_status)
    player_data = player_status.match(/# *(\d+) +"(.*)" +(.*)/).to_a[1..-1]
    player_data[2] = player_data[2].split
    player_data.flatten!
    player_data.delete_at(3)
    player_data
  end
end

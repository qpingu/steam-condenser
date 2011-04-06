# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2008-2011, Sebastian Staudt

require 'socket'
require 'timeout'

require 'exceptions/rcon_ban_exception'
require 'steam/packets/rcon/rcon_packet'
require 'steam/packets/rcon/rcon_packet_factory'
require 'steam/sockets/steam_socket'

class RCONSocket
  include SteamSocket

  def initialize(remote_host, remote_port, local_host = nil, local_port = nil)
    super remote_host, remote_port, local_host, local_port
  end

  # Closes the underlying socket if it exists
  def close
    super unless @socket.nil?
  end

  def connect
    begin
      timeout(SteamSocket.timeout / 1000.0) { @socket = TCPSocket.new @host, @port, @local_host, @local_port }
    rescue Timeout::Error
      raise TimeoutException
    end
  end

  def send(data_packet)
    connect if @socket.nil? || @socket.closed?
    super
  end

  def reply
    raise RCONBanException if receive_packet(4) == 0

    @buffer.rewind
    remaining_bytes = @buffer.long

    packet_data = ''
    begin
      received_bytes = receive_packet remaining_bytes
      remaining_bytes -= received_bytes
      packet_data << @buffer.get
    end while remaining_bytes > 0

    RCONPacketFactory.packet_from_data(packet_data)
  end
end

# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2008-2011, Sebastian Staudt

require 'socket'

require 'stringio_additions'
require 'exceptions/timeout_exception'

# This module defines common methods for sockets used to connect to game and
# master servers.
#
# @author Sebastian Staudt
# @see GoldSrcSocket
# @see MasterServerSocket
# @see RCONSocket
# @see SourceSocket
# @since sdds
module SteamSocket
  class << self
    attr_accessor :timeout
    @timeout = 1000
  end

  def initialize(ip, port = 27015)
    @socket = UDPSocket.new
    @socket.connect ip, port
  end

  # Closes the underlying socket
  def close
    @socket.close
  end

  def receive_packet(buffer_length = 0)
    if select([@socket], nil, nil, @@timeout / 1000.0).nil?
      raise TimeoutException
    end

    if buffer_length == 0
      @buffer.rewind
    else
      @buffer = StringIO.allocate buffer_length
    end

    data = @socket.recv @buffer.remaining
    bytes_read = @buffer.write data
    @buffer.truncate bytes_read
    @buffer.rewind

    bytes_read
  end

  def send(data_packet)
    puts "Sending data packet of type \"#{data_packet.class.to_s}\"." if $DEBUG

    @socket.send data_packet.to_s, 0
  end
end

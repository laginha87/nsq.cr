require "socket"

module NSQ
  class Connection
    property host : String
    property port : String
    property socket : TCPSocket

    def initialize(nsd_address : String)
      @host, @port = nsd_address.split(":")
      @socket = TCPSocket.new(host, port)
    end

    def sub(topic : String, channel : String, message_channel : Channel(Message))
      identify
      send_method Protocol.sub(topic, channel)
      read
      send_method("RDY 1\n")
      spawn_loop { message_channel.send(read.as(Message)) }
    end

    def identify
      data = {"client_id": "worker_1", "hostname": "hostname", "feature_negotiation": false}.to_json
      @socket << Protocol::MAGIC_V2
      send(Protocol.identify, data)
      read
    end

    def read
      frame_size = Int32.from_io(@socket, IO::ByteFormat::BigEndian)
      frame_type = Int32.from_io(@socket, IO::ByteFormat::BigEndian)
      case frame_type
      when Protocol::FRAME_TYPE_RESPONSE
        slice = Bytes.new(frame_size)
        @socket.read(slice)
        String.new(slice).rstrip('\u0000')
      when Protocol::FRAME_TYPE_ERROR
        slice = Bytes.new(frame_size)
        @socket.read(slice)
        String.new(slice).rstrip('\u0000')
      else Protocol::FRAME_TYPE_MESSAGE
        body_slice = Bytes.new(frame_size - 26)
        message_id_slice = Bytes.new(16)
        timestamp = Int64.from_io(@socket, IO::ByteFormat::BigEndian)
        attempts  = UInt16.from_io(@socket, IO::ByteFormat::BigEndian)
        @socket.read(message_id_slice)
        @socket.read(body_slice)
        Message.new(
          id: String.new(message_id_slice),
          timestamp: timestamp,
          attempts: attempts,
          body: String.new(body_slice).rstrip('\u0000'))
      end
    end

    private def send(method, data)
      send_method method
      send_data data
    end

    private def send_method(method)
      @socket << method
    end

    private def send_data(data)
      data.bytesize.to_i32.to_io(@socket, IO::ByteFormat::BigEndian)
      @socket << data
    end
  end
end

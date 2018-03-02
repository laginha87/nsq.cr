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
    end

    def identify
        data = {"client_id": "worker_1", "hostname": "hostname", "feature_negotiation": false}.to_json
        send(Protocol::IDENTIFY, data)
        read
    end

    def read
        size = Int32.from_io(@socket, IO::ByteFormat::BigEndian)
        Int32.from_io(@socket, IO::ByteFormat::BigEndian)
        slice = Bytes.new(size)
        @socket.read(slice)
        String.new(slice)
    end

    def send(method, data)
        @socket << Protocol::MAGIC_V2
        @socket << method
        data.bytesize.to_i32.to_io(@socket, IO::ByteFormat::BigEndian)
        @socket << data
    end
  end
end

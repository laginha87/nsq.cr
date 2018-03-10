module NSQ
  class Connection
    property host : String
    property port : String
    property socket : TCPSocket
    property options : Protocol::ClientOptions

    def initialize(nsd_address : String)
      initialize(nsd_address, Protocol::DEFAULT_OPTIONS)
    end

    def initialize(nsd_address : String, @options)
      @host, @port = nsd_address.split(":")
      @socket = TCPSocket.new(host, port)
    end

    def sub(topic : String, channel : String, message_channel : Channel(Message))
      identify
      send_method Protocol.sub(topic, channel)
      read
      send_method("RDY 1\n")
      spawn_loop do
        case msg = read
        when Message
          message_channel.send(msg)
        when "_heartbeat_"
          self.nop
        else
          Log.logger.info(msg)
        end
      end
    end

    def identify
      @socket << Protocol::MAGIC_V2
      send(Protocol.identify, @options.to_json)
      read
    end

    def fin(id)
      @socket.puts "FIN #{id}"
    end

    def touch(id)
      @socket.puts "TOUCH #{id}"
    end

    def req(id, defer = 0)
      @socket.puts "REQ #{id} #{defer}"
    end

    def nop
      @socket.puts "NOP"
    end

    def read
      frame_size = read_int
      case read_int
      when Protocol::FRAME_TYPE_RESPONSE
        read_string(frame_size - 4)
      when Protocol::FRAME_TYPE_ERROR
        read_string(frame_size - 4)
      else Protocol::FRAME_TYPE_MESSAGE
      Message.new(
        timestamp: read_int(Int64),
        attempts: read_int(UInt16),
        id: read_string(16),
        body: read_string(frame_size - 26 - 4),
        connection: self)
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

    private def read_int(t = Int32)
      t.from_io(@socket, IO::ByteFormat::BigEndian)
    end

    private def read_string(size = Int)
      @socket.gets(size).not_nil!
    end
  end
end

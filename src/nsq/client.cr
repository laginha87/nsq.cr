module NSQ
  class Client
    property lookup_addresses : Array(String)
    property connections : Array(Connection)

    def initialize(lookup_address : String)
      initialize [lookup_address]
    end

    def initialize(lookup_addresses : Array(String))
      initialize lookup_addresses, Protocol::DEFAULT_OPTIONS
    end

    def initialize(@lookup_addresses : Array(String), options : Protocol::ClientOptions)
      @connections = @lookup_addresses.map { |c| Connection.new(c, options) }
    end

    def subscribe(topic, channel, block)
      message_channel = Channel(Message).new
      @connections.each &.sub(topic, channel, message_channel)
      listen_to_channel(message_channel, block)
    end

    def subscribe(topic, channel, &block : Message ->)
      subscribe(topic, channel, block)
    end
  end
end

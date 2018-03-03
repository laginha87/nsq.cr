module NSQ
    class Client
        property lookup_address
        property conn

        def initialize(@lookup_address : String)
            @conn = Connection.new(@lookup_address)
        end

        def subscribe(topic, channel, block)
            message_channel = Channel(Message).new
            @conn.sub(topic, channel, message_channel)
            listen_to_channel(message_channel, block)
        end
    end
end
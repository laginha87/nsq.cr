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
            spawn do
                loop do
                    select
                    when msg = message_channel.receive
                        block.call(msg)
                    else
                        sleep 1
                    end
                end
            end
        end
    end
end
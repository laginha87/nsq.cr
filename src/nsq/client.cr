module NSQ
    class Client
        property lookup_address
        property conn

        def initialize(@lookup_address : String)
            @conn = Connection.new(@lookup_address)
        end

        def subscribe(topic, channel)
        end
    end
end
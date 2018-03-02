require "socket"

module NSQ
    class Message
        property body : String
        def initialize(@body)
        end
    end
end
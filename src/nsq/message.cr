require "socket"

module NSQ
  class Message
    property body : String
    property id : String
    property attempts : UInt16
    property timestamp : Int64

    def initialize(@body, @attempts, @timestamp, @id)
    end
  end
end

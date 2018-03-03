module NSQ
  class Message
    property body : String
    property id : String
    property attempts : UInt16
    property timestamp : Int64
    property connection : Connection?

    def initialize(@body, @attempts, @timestamp, @id, @connection = nil)
    end

    def connection
      @connection.not_nil!
    end

    def finish
      connection.fin(@id)
    end

  end
end

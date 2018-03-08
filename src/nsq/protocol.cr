module NSQ::Protocol
  MAGIC_V2            = "  V2"
  IDENTIFY            = "IDENTIFY\n"
  SUB                 = "SUB"
  FRAME_TYPE_RESPONSE = 0
  FRAME_TYPE_ERROR    = 1
  FRAME_TYPE_MESSAGE  = 2

  def self.identify
    IDENTIFY
  end

  def self.sub(topic, channel)
    "#{SUB} #{topic} #{channel}\n"
  end

  struct ClientOptions
    JSON.mapping(
      client_id: String,
      hostname: String,
      heartbeat_interval: {type: Int32, nilable: true},
      feature_negotiation: Bool
    )

    def initialize(@client_id, @hostname, @heartbeat_interval = nil, @feature_negotiation = false)
    end
  end

  DEFAULT_OPTIONS = ClientOptions.new(client_id: "nsq.cr", hostname: "localhost")
end

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
end

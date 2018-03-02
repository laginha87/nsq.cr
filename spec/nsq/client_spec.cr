require "../spec_helper"
require "json"

def send_message(topic, channel, message)
  JSON.parse `curl -d '#{message}' '#{NSQD_1_HTTP_ADDRESS}/pub?topic=#{topic}&channel=#{channel}' 2> /dev/null`
end

TOPIC = "topic_1"
CHANNEL = "channel_1"

module NSQ
  describe Client do
    it "initializes" do
      client = Client.new(NSQD_1_TCP_ADDRESS)
      client.lookup_address.should eq(NSQD_1_TCP_ADDRESS)
      client.conn.should_not eq(nil)
    end

    it "subscribes to a channel" do
      client = Client.new(NSQD_1_TCP_ADDRESS)
      assertion_channel = Channel(String).new

      callback = ->(message : Message) do
        assertion_channel.send(message.body)
      end
      client.subscribe(TOPIC, CHANNEL, callback)

      send_message(TOPIC, CHANNEL, "YEY")
      assertion_channel.receive.should be("YEY")
    end
  end
end

require "../spec_helper"
require "json"

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
      assertion_channel.receive.should eq("YEY")
    end
  end
end

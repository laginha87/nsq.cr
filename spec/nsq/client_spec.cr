require "../spec_helper"

module NSQ
  describe Client do
    it "initializes" do
      client = Client.new(NSQD_1_TCP_ADDRESS)
      client.lookup_addresses.should eq([NSQD_1_TCP_ADDRESS])
      client.connections.should_not eq(nil)
    end

    it "subscribes to a channel" do
      client = Client.new(NSQD_1_TCP_ADDRESS)
      assertion_channel = Channel(String).new

      callback = ->(message : Message) do
        assertion_channel.send(message.body)
      end
      client.subscribe(NSQHelper.topic, NSQHelper.channel, callback)

      send_message(NSQHelper.topic, NSQHelper.channel, "YEY")
      assertion_channel.receive.should eq("YEY")
    end

    it "subscribes to a channel on mulitple nsqd instances" do
      client = Client.new([NSQD_1_TCP_ADDRESS, NSQD_2_TCP_ADDRESS])
      assertion_channel = Channel(String).new

      callback = ->(message : Message) do
        assertion_channel.send(message.body)
        message.finish
      end
      client.subscribe(NSQHelper.topic, NSQHelper.channel, callback)

      send_message(NSQHelper.topic, NSQHelper.channel, "YEY")
      send_message(NSQHelper.topic, NSQHelper.channel, "YEY_2")
      messages = 2.times.map { assertion_channel.receive }
      messages.to_a.should eq(["YEY", "YEY_2"])
    end
  end
end

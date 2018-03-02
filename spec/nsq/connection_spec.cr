require "../spec_helper"
require "json"


module NSQ
  describe Connection do
    it "initializes" do
      connection = Connection.new(NSQD_1_TCP_ADDRESS)
      connection.host.should eq "localhost"
      connection.port.should eq NSQD_1_TCP_PORT
    end

    it "can initialize the connection to nsqd" do
        connection = Connection.new(NSQD_1_TCP_ADDRESS)
        connection.identify().should eq("OK")
    end

    it "subscribes to a channel" do
      client = Connection.new(NSQD_1_TCP_ADDRESS)
      message_channel = Channel(Message).new
      client.sub(TOPIC, CHANNEL, message_channel)
      send_message(TOPIC, CHANNEL, "YEY")

      message_channel.receive.body.should eq("YEY")
    end
  end
end

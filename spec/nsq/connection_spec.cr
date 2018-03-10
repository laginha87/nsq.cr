require "../spec_helper"
require "json"

private def generate_connection
  NSQ::Connection.new(NSQD_1_TCP_ADDRESS, NSQ::Protocol::DEFAULT_OPTIONS)
end

module NSQ
  describe Connection do
    it "initializes" do
      connection = generate_connection
      connection.host.should eq "localhost"
      connection.port.should eq NSQD_1_TCP_PORT
    end

    it "can initialize the connection to nsqd" do
      connection = generate_connection
      connection.identify.should eq("OK")
    end

    it "subscribes to a channel" do
      connection = generate_connection
      message_channel = Channel(Message).new
      connection.sub(NSQHelper.topic, NSQHelper.channel, message_channel)
      send_message(NSQHelper.topic, NSQHelper.channel, "YEY")

      message_channel.receive.body.should eq("YEY")
    end

    it "responds to heartbeats" do
      options = Protocol::ClientOptions.new(client_id: "nsq.cr", hostname: "localhost", heartbeat_interval: 1000)
      connection = NSQ::Connection.new(NSQD_1_TCP_ADDRESS, options)
      message_channel = Channel(Message).new
      connection.sub(NSQHelper.topic, NSQHelper.channel, message_channel)
      sleep 2
      send_message(NSQHelper.topic, NSQHelper.channel, "YEY")
      message_channel.receive.body.should eq("YEY")
    end
  end
end

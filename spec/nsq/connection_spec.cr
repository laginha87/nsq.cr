require "../spec_helper"
require "json"

def send_message(topic, channel, message)
  JSON.parse `curl -d '#{message}' '#{NSQD_1_HTTP_ADDRESS}/pub?topic=#{topic}&channel=#{channel}' 2> /dev/null`
end

TOPIC = "topic_1"
CHANNEL = "channel_1"

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
  end
end

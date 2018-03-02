require "../spec_helper"
require "json"


def stat_channel(topic, channel)
    JSON.parse `curl 'localhost:4151/stats?topic=foo&channel=bar&format=json'`
end

module NSQ
    describe Client do
        it "initializes" do
            client = Client.new("localhost:4150")
            client.lookup_address.should eq("localhost:4150")
            client.conn.should_not eq(nil)
        end

        it "subscribes to a channel" do
            client = Client.new("localhost:4150")

            client.subscribe("topic_1", "channel_1")
            channel = stat_channel("topic_1", "channel_1")
            channel["topics"].size.should eq(1)
        end
    end
end
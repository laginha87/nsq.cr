require "spec"
require "./initializers/*"

require "../src/nsq.cr"

def send_message(topic, channel, message)
  `curl -d '#{message}' '#{NSQD_1_HTTP_ADDRESS}/pub?topic=#{topic}&channel=#{channel}' &> /dev/null`
end
TOPIC = "topic_1"
CHANNEL = "channel_1"
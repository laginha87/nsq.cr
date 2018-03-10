# Subscribes to the channel and it ouptuts everything
require "../src/nsq"

puts "Getting started"

client = NSQ::Client.new("localhost:9002")

callback = ->(message : NSQ::Message) do
  puts message.body
  message.finish
end

client.subscribe("topic_1", "channel_1", callback)

def send_message(topic, message)
  `curl -d '#{message}' 'localhost:9001/pub?topic=#{topic}' &> /dev/null`
end

1.upto(100).each do |e|
  send_message("topic_1", "Hello #{e}")
end

loop do
  sleep(10)
end

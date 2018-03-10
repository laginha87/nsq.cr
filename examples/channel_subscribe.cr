# Subscribes to the channel and it ouptuts everything
require "../src/nsq"

puts "Getting started"

client = NSQ::Client.new("localhost:9002")

client.subscribe("topic_1", "channel_1") do |message|
  puts message.body
  message.finish
end

def send_message(topic, message)
  `curl -d '#{message}' 'localhost:9001/pub?topic=#{topic}' &> /dev/null`
end

1.upto(100).each do |e|
  send_message("topic_1", "Hello #{e}")
end

loop do
  sleep(10)
end

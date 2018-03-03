require "spec"
require "./initializers/*"

require "../src/nsq.cr"

def send_message(topic, channel, message)
  `curl -d '#{message}' '#{NSQD_1_HTTP_ADDRESS}/pub?topic=#{topic}&channel=#{channel}' &> /dev/null`
end

def send_message_nsqd_2(topic, channel, message)
  `curl -d '#{message}' '#{NSQD_2_HTTP_ADDRESS}/pub?topic=#{topic}&channel=#{channel}' &> /dev/null`
end

def clean_up_nsqds
  `curl -X POST '#{NSQD_1_HTTP_ADDRESS}/topic/empty?topic=#{NSQHelper.topic}' &> /dev/null`
  `curl -X POST '#{NSQD_2_HTTP_ADDRESS}/topic/empty?topic=#{NSQHelper.topic}' &> /dev/null`
end

class NSQHelper
  def self.generate
    seed = (rand * 1000).to_i
    @@channel = "channel_#{seed}"
    @@topic = "topic_#{seed}"
  end

  def self.topic
    @@topic.not_nil!
  end

  def self.channel
    @@channel.not_nil!
  end
end

Spec.before_each do
  NSQHelper.generate
end

Spec.after_each do
  clean_up_nsqds
end

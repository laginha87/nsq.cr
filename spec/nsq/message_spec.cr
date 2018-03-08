require "../spec_helper"
require "json"

macro tcp_server_eq(message, &block)
  channel = Channel(Nil).new
  server = TCPServer.new("localhost", 51234)
  spawn do
    server.accept do |client|
      message = client.gets
      message.should eq ({{message}})
    end
    server.close
    channel.send nil
  end
  host = "localhost:51234"
  {{block.body}}
  channel.receive
end

module NSQ
  describe Message do
    it "initializes" do
      message = Message.new(attempts: 1.to_u16, id: "1", timestamp: 10000.to_i64, body: "body", connection: nil)
      message.attempts.should eq 1
      message.id.should be "1"
      message.timestamp.should eq 10000
      message.body.should be "body"
    end

    it "touches" do
      tcp_server_eq("TOUCH 1234") do |host|
        conn = Connection.new host
        message = Message.new(attempts: 1.to_u16, id: "1234", timestamp: 10000.to_i64, body: "body", connection: conn)
        message.touch
      end
    end

    it "requeues" do
      tcp_server_eq("REQ 1234 0") do |host|
        conn = Connection.new host
        message = Message.new(attempts: 1.to_u16, id: "1234", timestamp: 10000.to_i64, body: "body", connection: conn)
        message.requeue
      end
    end
  end
end

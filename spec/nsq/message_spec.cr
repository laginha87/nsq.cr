require "../spec_helper"
require "json"


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
      channel = Channel(Nil).new
      spawn do
        server = TCPServer.new("localhost", 3000)
        server.accept do |client|
          message = client.gets
          message.should eq ("TOUCH 1234")
          channel.send(nil)
          server.close
        end
      end
      conn = Connection.new "localhost:3000"
      message = Message.new(attempts: 1.to_u16, id: "1234", timestamp: 10000.to_i64, body: "body", connection: conn)
      message.touch
      channel.receive
    end

    it "requeues" do
      channel = Channel(Nil).new
      spawn do
        server = TCPServer.new("localhost", 3000)
        server.accept do |client|
          message = client.gets
          message.should eq ("REQ 1234 0")
          channel.send(nil)
          server.close
        end
      end
      conn = Connection.new "localhost:3000"
      message = Message.new(attempts: 1.to_u16, id: "1234", timestamp: 10000.to_i64, body: "body", connection: conn)
      message.requeue
      channel.receive
    end


  end
end

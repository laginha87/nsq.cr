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
  end
end

File.read(".env")
    .each_line
    .map(&.chomp)
    .reject(&.empty?)
    .map(&.split("="))
    .each do |(name, val)|
  ENV[name] = val
end

NSQD_1_TCP_PORT    = ENV["NSQD_1_TCP_PORT"]
NSQD_1_TCP_ADDRESS = "localhost:#{ENV["NSQD_1_TCP_PORT"]}"
NSQD_2_TCP_ADDRESS = "localhost:#{ENV["NSQD_2_TCP_PORT"]}"

NSQD_1_HTTP_ADDRESS = "localhost:#{ENV["NSQD_1_HTTP_PORT"]}"
NSQD_2_HTTP_ADDRESS = "localhost:#{ENV["NSQD_2_HTTP_PORT"]}"

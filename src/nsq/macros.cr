macro spawn_loop(&block)
    {% begin %}
    spawn do
        loop {{block}}
    end
{% end %}
end

macro listen_to_channel(channel, block)
    {% begin %}
    spawn do
        sleep_channel = Channel(Nil).new
        spawn do
            loop do
                sleep 1.second
                sleep_channel.send(nil)
            end
        end
        loop do
            select
            when msg = {{channel}}.receive
                {{block}}.call(msg)
            when sleep_channel.receive
            end
        end
    end
    {% end %}
end

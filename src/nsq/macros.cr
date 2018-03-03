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
        loop do
            select
            when msg = {{channel}}.receive
                {{block}}.call(msg)
            else
                sleep 1
            end
        end
    end
    {% end %}
end

module MyUDPServer
using ToolipsUDP

CLIENTS = Dict{String, Pair{<:Number, <:Number}}()


default_handler = handler() do c::UDPConnection
    f = findfirst(c::Char -> ~(isnumeric(c) || c == "."), c.packet)
    if ~(isnothing(f))
        respond!(c, "we need the first operand, that is not a number.")
        return
    end
    f = 0
    if ~(contains(c.packet, "."))
        f = parse(Float64, c.packet)
    else
        f = parse(Int64, c.packet)
    end
    CLIENTS[get_ip(c)] = f => 0
    set_handler!(c, "second")
    respond!(c, string(f))
end

second_handler = handler("second") do c::UDPConnection
    f = findfirst(c::Char -> ~(isnumeric(c) || c == "."), c.packet)
    if ~(isnothing(f))
        respond!(c, "we need the second operand, that is not a number.")
        return
    end
    f = 0
    if ~(contains(c.packet, "."))
        f = parse(Float64, c.packet)
    else
        f = parse(Int64, c.packet)
    end
    CLIENTS[get_ip(c)] = CLIENTS[get_ip(c)][1] => f
    set_handler!(c, "operation")
    respond!(c, string(f))
end

op_handler = handler("operation") do c::UDPConnection
    op = c.packet
    if op in ("+", "-", "/", "^")
        args = CLIENTS[get_ip(c)]
        respond!(c, string(eval(Meta.parse("$(args[1]) $op $(args[2])"))))
        remove_handler!(c)
    else
        respond!(c, "we need the operator. bad input")
    end
end

multi_hand = ToolipsUDP.MultiHandler(default_handler)

export second_handler, op_handler, start!, UDP
export multi_hand
end

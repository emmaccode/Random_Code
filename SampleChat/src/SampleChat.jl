module SampleChat
using ToolipsUDP
import Base: getindex

mutable struct Client
    ip::IP4
    name::String
    connected::IP4
end

function getindex(clients::Vector{Client}, ip::IP4)
    found = findfirst(client -> client.ip == ip, clients)
    if isnothing(found)
        throw(BoundsError())
    end
    clients[found]::Client
end

function getindex(clients::Vector{Client}, name::String)
    found = findfirst(client -> client.name == name, clients)
    if isnothing(found)
        throw(BoundsError())
    end
    clients[found]::Client
end

CLIENTS = Vector{Client}()

main_handler = handler() do c::UDPConnection
    println(c.packet, "\nconnected\n$(c.ip)")
    set_handler!(c, "nameset")
    respond!(c, "welcome to the chat, what name would you like to go by?")
end

name_set_handler = handler("nameset") do c::UDPConnection
    name = c.packet
    if contains(name, " ")
        respond!(c, "your name cannot contain spaces")
        return
    end
    allnames = [client.name for client in CLIENTS]
    if name in allnames
        respond!(c, "$name is taken. Please try another username.")
        return
    end
    push!(CLIENTS, Client(get_ip4(c), name, "1.1":0))
    instructions = "select a user to message by entering their number.\n"
    set_handler!(c, "set_connected")
    respond!(c, instructions * join((begin 
    "[$(e)]: $(c.name)"
end for (e, c) in enumerate(CLIENTS)), "\n"))
end

sconnected_handler = handler("set_connected") do c::UDPConnection
    selected::Int64 = 0
    try
        selected = parse(Int64, c.packet)
    catch
        respond!(c, "not a valid selection.")
        return
    end
    current_ip4 = get_ip4(c)
    selected_ip4 = CLIENTS[selected].ip
    CLIENTS[current_ip4].connected = selected_ip4
    CLIENTS[selected].connected = current_ip4
    respond!(c, "connected to chat! use 'exit' to exit")
    set_handler!(c, "sendchat")
    set_handler!(c, selected_ip4, "sendchat")
end

chat_handler = handler("sendchat") do c::UDPConnection
    new_chat = c.packet
    if new_chat == "exit"
        instructions = "exiting chat.\nselect a user to message by entering their number."
        respond!(c, instructions * join((begin 
            "[$(e)]: $(c.name)"
        end for (e, c) in enumerate(clients)), "\n"))
        set_handler!(c, "set_connected")
        return
    end
    send(c, new_chat, CLIENTS[get_ip4(c)].connected)
    respond!(c, "YOU: $(new_chat)")
end

module ClientServer
using SampleChat.ToolipsUDP
using SampleChat.ToolipsUDP: Crayon

CONNECTED::IP4 = "1.1":5

main_handler = handler() do c::UDPConnection
    if contains(c.packet, "YOU:")
        print(Crayon(foreground = :blue))
        println(c.packet)
        print(Crayon(foreground = :white))
        return
    end
    println(c.packet)
end


function connect(ip::IP4, from::IP4)
    CONNECTED = ip
    @async start!(UDP, ClientServer, ip = from, async = false)
    while true
        new_packet = readline()
        send(ClientServer, new_packet, CONNECTED)
    end
end

export main_handler
end #ClientServer

multi_handler = ToolipsUDP.MultiHandler(main_handler)
# start
export start!, UDP
# handlers
export name_set_handler, sconnected_handler, chat_handler
# extensions
export multi_handler
end

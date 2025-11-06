module RPCSample
using Toolips
using Toolips.Components
using ToolipsSession

#==
extensions
==#
logger = Toolips.Logger()
session = ToolipsSession.Session()

main = route("/") do c::Toolips.AbstractConnection
    rpc_header = h2(text = "toolips session RPC demonstration")
    style!(rpc_header, "color" => "white")
    color_div = div("colordiv")
    style!(color_div, "background-color" => "#1e1e1e", "width" => 80percent, "height" => 20percent, "padding" => 1.5percent, 
    "transition" => 2000ms)
    push!(color_div, rpc_header)
    colorbox = Components.colorinput("colin", value = "#1e1e1e")
    call_color = button("callsample", text = "call!")
    on(c, call_color, "click") do cm::ComponentModifier
        color = cm["colin"]["value"]
        style!(cm, "colordiv", "background-color" => color)
        call!(c, cm)
        alert!(cm, "changed color for everybody but you")
    end
    rpc_color = button("rpcsample", text = "rpc!")
    on(c, rpc_color, "click") do cm::ComponentModifier
        color = cm["colin"]["value"]
        style!(cm, "colordiv", "background-color" => color)
        rpc!(c, cm)
    end
    common = ("background-color" => "#1e1e1e", "font-weight" => "bold", "padding" => .5percent, "color" => "white")
    style!(call_color, common ...)
    style!(rpc_color, common ...)
    
    if ~(:host in c)
        # open RPC
        open_rpc!(c, tickrate = 200)
        push!(c.data, :host => ToolipsSession.get_session_key(c))
    elseif ToolipsSession.get_session_key(c) == c[:host]
        open_rpc!(c, tickrate = 200)
    else
        join_rpc!(c, c[:host])
    end
    host_event = ToolipsSession.find_host(c)
    all_clients = (host_event.name, host_event.clients ...)
    selector_options = [begin
        client_button = button("person", text = "client $e")
        on(c, client_button, "click") do cm::ComponentModifier
            call_color!(c, cm, client)
        end
        client_button
    end for (e, client) in enumerate(all_clients)]

    selector = div("callselector", children = selector_options)

    style!(selector, "background-color" => "#a12c23", "border-radius" => 3pt, "min-width" => 1percent, "min-height" => 1percent)
    controldiv = div("controldiv", children = [colorbox, call_color, rpc_color, selector])

    mainbod = body("main", children = [color_div, controldiv])
    style!(mainbod, "background-color" => "#4a193a")
    write!(c, mainbod)
    nothing::Nothing
end

function call_color!(c, cm, client)
    if client == ToolipsSession.get_session_key(c)
        return
    end
    # these changes will be made for `client` only.
    color = cm["colin"]["value"]
    style!(cm, "colordiv", "background-color" => color)
    call!(c, cm, client)
    # these changes will only happen for the clicker
    alert!(cm, "the color has changed")
    nothing::Nothing
end

# make sure to export!
export start!, main, default_404, logger, session
end # - module RPCSample <3
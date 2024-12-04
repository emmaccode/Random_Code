module PrettyDash
using Toolips
using Toolips.Components
using DataFrames
using CSV
using Gattino
using GattinoPleths
using ToolipsSession

pleth_data = CSV.read("pages/plethdata.csv", DataFrame)
df1 = CSV.read("pages/df1.csv", DataFrame)
sorted_cop = CSV.read("pages/sortedcop.csv", DataFrame)

x = df1[!, "U.S. Wildfires October"]
y = df1[!, "no. fires"]

linevis = context(550, 550) do con::Context
    ymax = 20000
    ymin = 0
    group!(con, "n_fires") do group1::Group
        # n _fires
    group(con, 400, 200, 10 => 50) do g::Group
        Gattino.labeled_grid!(g, x, Array(0:20000), [2000, 2005, 2010, 2015, 2024], [0, 5000, 10000, 15000])
        Gattino.line!(g, x, y, ymax = 15000, ymin = 0, "stroke" => "red", "fill" => "none")
        Gattino.gridlabels!(g, x, y, 4, "fill" => "black", "stroke" => "black", "font-size" => 20pt, ymax = ymax, ymin = ymin)
    end
    end
    
    global y = df1[!, "acres per fire"]
    group(con, 400, 200, 10 => 300) do g::Group
        Gattino.labeled_grid!(g, x, Array(0:20000), [2000, 2005, 2010, 2015, 2024], [0, 10000, 15000, 20000])
        Gattino.line!(g, x, y, ymax = 500, ymin = 0, "stroke" => "green", "fill" => "none")
        Gattino.gridlabels!(g, x, y, 4, "fill" => "black", "stroke" => "black", "font-size" => 20pt, ymax = ymax, ymin = ymin)
    end
    group!(con, "labels") do g
        Gattino.text!(g, 350, 30, "number of fires", "font-weight" => "bold", "font-size" => 13pt, "fill" => "red")
        Gattino.text!(g, 420, 50, "15,000", "font-weight" => "bold", "font-size" => 10pt, "fill" => "darkred")
        Gattino.text!(g, 420, 250, "0", "font-weight" => "bold", "font-size" => 10pt, "fill" => "darkblue")
        Gattino.text!(g, 350, 280, "acres burned", "font-weight" => "bold", "font-size" => 13pt, "fill" => "green")
                Gattino.text!(g, 420, 310, "500", "font-weight" => "bold", "font-size" => 10pt, "fill" => "darkred")
        Gattino.text!(g, 420, 500, "0", "font-weight" => "bold", "font-size" => 10pt, "fill" => "darkgreen")
    end
end
sorted_cop[!, "state"] = [String(n) for n in sorted_cop[!, "state"]]
pleth_data[!, "state"] = [String(n) for n in pleth_data[!, "state"]]
sev_most = Gattino.hist(sorted_cop[!, "state"][1:5], sorted_cop[!, "no fires"][1:5], width = 750, title = "5 states with most wildfires")

colors = Gattino.make_gradient((0, 0, 255), 30, 20, 0, -20)

new_pleth = choropleth(pleth_data[!, "state"], pleth_data[!, "no fires"], GattinoPleths.usa_map, 
    colors)
GattinoPleths.choropleth_legend!(new_pleth, "less fires" => "more fires", colors, align = "bottom-left")

# extensions
logger = Toolips.Logger()

mutable struct Page
    name::String
    md_path::String
    vis::Vector{Components.Servable}
    Page(name::String, path::String, vis::Components.Servable ...) = begin
        new(name, path, Vector{Servable}([vis ...]))
    end
end

pages = [Page("overview", "pages/overview.md", linevis.window), 
    Page("fire frequency", "pages/frequency.md", sev_most.window, linevis.window), 
    Page("fire by state", "pages/states.md", sev_most.window, new_pleth.window)]

main_header = div("main_header")
style!(main_header, "margin-left" => 6percent, "background-color" => "white", "width" => 70percent, "padding" => 2percent)

app_name = div("app_name", text = "insights on U.S. wildfires", align = "left")
style!(app_name, "color" => "#fc3503", "font-size" => 24pt, "opacity" => 80percent, "margin-bottom" => 20px)

menu_container = div("menu")

push!(main_header, app_name, Component{:sep}(), menu_container)

main_content = div("main-content")
style!(main_content, "display" => "inline-flex", "width" => 70percent, "height" => 75percent, "margin-left" => 6percent, "background-color" => "white", 
"padding" => 2percent)

text_content = div("text-content")

style!(text_content, "border-radius" => 2px, "width" => 45percent, "padding" => 1percent, 
"color" => "#333A3A", "font-size" => 13pt, "max-height" => 60percent, "min-height" => 60percent, "display" => "inline-block", 
"vertical-align" => "top", "overflow-y" => "scroll")

vis_content = div("vis-content")
style!(vis_content, "border-radius" => 2px, "border" => "2px solid #333333", "width" => 48percent, "padding" => 1percent, 
"max-height" => 80percent, "min-height" => 80percent, "display" => "inline-block", "overflow-x" => "hidden", "overflow-y" => "scroll")

push!(main_content, text_content, vis_content)


newsheet = Component{:stylesheet}(("mainsheet"))

button_s = style("button", "transition" => 500ms)
button_s:"hover":["transform" => "scale(1.1)"]
p_s = style("p", "font-size" => 13pt, "color" => "#333A3D")
a_s = style("a", "font-size" => 13pt, "color" => "purple")
h1_s = style("h1", "font-size" => 22pt, "font-weight" => "bold", "color" => "#333333")
h2_s = style("h2", "font-size" => 20pt, "font-weight" => "bold", "color" => "darkblue")
h3_s = style("h3", "font-size" => 20pt, "color" => "gray")
h6_s = style("h6", "font-size" => 20pt, "color" => "purple")
hover_bars = style("rect.hoverbars", "transition" => 250ms)
hover_bars:"hover":["transform" => "scale(1.05)"]
push!(newsheet, button_s, p_s, a_s, hover_bars)

main = route("/") do c::Toolips.AbstractConnection
    write!(c, newsheet)
    curs = Components.cursor("point-cursor")
    write!(c, curs)
    main_body = body("main")
    bars = sev_most[:children]["bars"][:children]
    for bar in 1:length(bars)
        bar_rect = bars[bar]
        on(c, bar_rect, "click") do cm::ComponentModifier
            cursorx, cursory = cm[curs]["x"], cm[curs]["y"]
            popup = div("popup")
            style!(popup, "position" => "absolute", "left" => cursorx, "top" => cursory, "background-color" => "pink", "border-radius" => 3px)
            state_name = sorted_cop[!, "state"][bar]
            no_fires = sorted_cop[!, "no fires"][bar]
            header = h1("popuph", text = state_name)
            lbl = p("popuplb", text = "number of fires: " * string(no_fires))
            push!(popup, header, lbl)
            on(popup, "click") do cl::ClientModifier
                remove!(cl, "popup")
            end
            append!(cm, "main", popup)
        end
        bar_rect["class"] = "hoverbars"
    end
    style!(main_body, "background-color" => "#a32c0f")
    client_content = copy(main_content)
    page_tmd = tmd("page-md", read(pages[1].md_path, String))
    set_children!(menu_container, [begin 
    newname = replace(menu.name, " " => "-")
    menbutton = button("men$newname", align = "center", text = menu.name)
    style!(menbutton, "border-radius" => 3px, "padding" => 5px, "font-size" => 18pt, "font-weight" => "bold", "cursor" => "pointer")
    on(c, menbutton, "click") do cl::ComponentModifier
        page_tmd = tmd("page-md", read(menu.md_path, String))
        set_children!(cl, "text-content", Vector{Servable}([page_tmd]))
        set_children!(cl, "vis-content", menu.vis)
    end
    menbutton
end for menu in pages])
    set_children!(client_content[:children]["text-content"], [page_tmd])
    set_children!(client_content[:children]["vis-content"], pages[1].vis)
    push!(main_body, main_header, client_content)
    write!(c, main_body)
end

session = Session()
# make sure to export!
export main, default_404, logger, session
end # - module PrettyDash <3
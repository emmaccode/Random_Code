module EmmysApp
using Toolips
using Toolips.Components
using ToolipsSession

SITEINFO = Dict("served" => 0, "unique" => 0, "name" => "emmys site")
# extensions
logger = Toolips.Logger()
SESSION = ToolipsSession.Session()

main = route("/") do c::Toolips.AbstractConnection
    main_body::Component{:body} = body("main", align = "center")
    style!(main_body, "background-color" => "#200521")
    fade_up::Components.KeyFrames = keyframes("fadeup")
    keyframes!(fade_up, 0percent, "opacity" => 0percent, "transform" => "translateY(20%)")
    keyframes!(fade_up, 100percent, "opacity" => 100percent, "transform" => "translateY(0%)")
    circ_class = style("circle.circ", "fill" => "pink", "stroke" => "purple", "stroke-width" => 2px, 
    "transition" => 750ms)
    circ_class:"hover":["transform" => scale(1.3), "stroke" => "lightgreen"]
    circ_selected = style("circle.selected", "fill" => "blue", 
    "stroke-width" => 5px, "stroke" => "green")
    style!(circ_class, fade_up)
    guy_image::Component{:img} = img("creatorguy", src = "/images/creatorcutie.png")
    heading = h2("creatorlabel", text = "creator's guessing game!")
    sub_heading = h4("subhead", text = "guess the randomly selected circle to win!")
    style!(guy_image, fade_up)
    style!(heading, fade_up)
    style!(sub_heading, fade_up)
    style!(heading, "font-size" => 22pt, "font-weight" => "bold", "color" => "white")
    style!(sub_heading, "font-size" => 16pt, "color" => "pink")
    my_svg::Component{:svg} = svg("mywindow", width = 600, height = 250, selected = "0")
    # we need to scale the circles to fit in the `600px` frame. (i meant to make this the width earlier)
    n::Int64 = 5
    correct_answer = string(rand(1:n))
    distance = (600 - 100) / n
    new_circles = [begin
        this_circle = Component{:circle}("circle$count", 
        r = 20, cy = 125, cx = count * distance, class = "circ")
        on(c, this_circle, "click") do cm::ComponentModifier
            cm["mywindow"] = "selected" => string(count)
            subm_b = button("subb", text = "submit")
            if ~("subb" in cm)
                style!(subm_b, "background-color" => "pink", "font-weight" => "bold", 
                "border" => "3px whitesmoke", "border-radius" => 3px, "padding" => 7px)
                on(c, subm_b, "click") do cm2::ComponentModifier
                    replay_button = button("reload", text = "replay?")
                    on(c, replay_button, "click") do cm::ComponentModifier
                        redirect!(cm, "http://$(get_host(c))")
                    end
                    remove!(cm2, "subb")
                    append!(cm2, "main", replay_button)
                    if cm2["mywindow"]["selected"] == correct_answer
                        style!(cm2, this_circle, "fill" => "darkgreen")
                        return
                    else
                        style!(cm2, this_circle, "fill" => "red")
                        style!(cm2, "circle$correct_answer", "fill" => "orange")
                    end
                end
                append!(cm, "main", subm_b)
            end
            cm[this_circle] = "class" => "selected"
            vals = Vector{Int64}()
            [cm["circle$val"] = "class" => "circ" for val in filter(number -> number != count, Vector(1:5))]
        end
        this_circle::Component{:circle}
    end for count in 1:n]
    set_children!(my_svg, new_circles)
    push!(main_body, fade_up, circ_class, circ_selected, 
    guy_image, heading, sub_heading, my_svg)
    write!(c, main_body)
end

api = route("/api") do c::Toolips.Connection
    SITEINFO["served"] += 1
    write!(c, "your existence has been made known.")
end

site_data = route("/api/siteinfo") do c::Connection
    incoming_method::String = get_method(c)
    req::String = ""
    if incoming_method == "GET"
        get_arguments::Dict{Symbol, String} = get_args(c)
        if haskey(get_arguments, :getdata)
            req = get_arguments[:getdata]
        else
            write!(c, "you made a GET request without the `getdata` argument. We don't know what you want.")
            return
        end
    else # (POST)
        req = get_post(c)
    end
    if req in keys(SITEINFO)
        write!(c, string(SITEINFO[req]))
        return
    end
    # client requests non-existing key
    write!(c, "key not found; the data you requested does not exist.")
end

four_o4 = route("404") do c::Connection
    write!(c, "this is our own 404 page :)")
end

public_files = mount("/" => "public")

# make sure to export!
export main, four_o4, site_data
export api, public_files
export SESSION, logger
end # - module EmmysApp <3
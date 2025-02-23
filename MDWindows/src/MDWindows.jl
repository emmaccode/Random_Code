module MDWindows
using Toolips
using Toolips.Components
using ToolipsSession

const DOCUMENTS_URI::String = "documents"
logger = Toolips.Logger()
SESSION = Session()

main = route("/") do c::Toolips.AbstractConnection
    # main box
    main_box = div("main")
    style!(main_box, "position" => "absolute", "overflow-x" => "show", "width" => 40percent, "height" => 60percent, "padding" => 5percent, 
    "top" => 0percent, "left" => 0percent)
    # handling `f` argument
    args = get_args(c)
    if haskey(args, :f)
        fname = replace(args[:f], "-" => " ") * ".md"
        markd = build_file(fname)
        push!(main_box, markd)
        write!(c, body("mainbody", children = [main_box]))
        return
    end
    file_button_style = style("div.filebutton", "padding" => 5percent, "margin" => 2percent, "color" => "#1e1e1e", "font-weight" => "bold", "font-size" => 15pt, 
    "border-radius" => 5px, "border" => "2px solid #1e1e1e", "cursor" => "pointer", "transition" => 850ms)
    file_button_style:"hover":["transform" => "scale(1.05)"]
    for md_filename in readdir(DOCUMENTS_URI)
        presentable_name = replace(md_filename, ".md" => "")
        comp_name = replace(presentable_name, " " => "-")
        fbut = div(comp_name, text = presentable_name, class = "filebutton")
        on(c, fbut, "click") do cm::ComponentModifier
            markd = build_file(md_filename)
            style!(markd, "position" => "absolute", "border" => "3px solid #333333", "width" => 20percent, "height" => 20percent, "z-index" => 7, "left" => 40percent, 
            "background-color" => "white")
            append!(cm, "mainbody", markd)
        end
        push!(main_box, fbut)
    end
    write!(c, file_button_style)
    write!(c, body("mainbody", children = [main_box]))
end

function build_file(fname::String)
    read_raw = read(DOCUMENTS_URI * "/$fname", String)
    tmd("mark", read_raw)
end

export start!, main, default_404, logger, SESSION
end # - module MDWindows <3
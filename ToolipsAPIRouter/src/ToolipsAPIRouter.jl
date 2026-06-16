module ToolipsAPIRouter
using Toolips
using JSON
import Toolips: route!

struct RQType{T} end

const POST = RQType{:post}()
const GET = RQType{:get}()

abstract type AbstractAPIRoute <: Toolips.AbstractHTTPRoute end

mutable struct APIRoute{T} <: AbstractAPIRoute
    path::String
    page::Function
    argnames::Vector{Symbol}
end

struct CombinedAPIRoute <: AbstractAPIRoute
    path::String
    routes::Pair{APIRoute{:get}, APIRoute{:post}}
end

function route!(c::AbstractConnection, route::CombinedAPIRoute)
    if get_method(c) == "POST"
        route!(c, route.routes[2])
    else
        route!(c, route.routes[1])
    end
end

function route!(c::AbstractConnection, route::APIRoute{:get})
    request_args = get_args(c)
    params = methods(route.page)[1].sig.parameters
    cast_types = length(params) > 2
    if cast_types
        params = params[3:end]
    end
    func_arguments = []
    for arg_n in 1:length(route.argnames)
        arg = route.argnames[arg_n]
        T = params[arg_n]
        if Base.haskey(request_args, arg)
            if cast_types && T != Any &&  !(T <: AbstractVector || T <: AbstractString)
                try
                    push!(func_arguments, parse(T, request_args[arg]))
                catch
                    write!(c, "Unable to parse value $(request_args[arg_n]) to $(params[arg_n])")
                end
            else
                push!(func_arguments, request_args[arg])
            end

        else
            write!(c, "Error with Request: Missing argument: $arg")
            return
        end
    end
    route.page(c, func_arguments ...)
end

function route!(c::AbstractConnection, route::APIRoute{:post})
    params = methods(route.page)[1].sig.parameters
    n = length(params)
    if n > 2
        postvalue = if params[3] <: AbstractDict
            JSON.parse(get_post(c), Dict)
        else
            get_post(c)
        end
        route.page(c, postvalue)
        return
    end
    route.page(c)
end

api_route(f::Function, rqt::RQType{<:Any}, path::AbstractString) = begin
    argnames = Base.method_argnames(methods(f)[1])
    if length(argnames) > 2
        argnames = argnames[3:end]
    else
        argnames = []
    end
    APIRoute{typeof(rqt).parameters[1]}(path, f, argnames)
end

api_route(r1::APIRoute{:get}, r2::APIRoute{:post}) = begin
    path = r1.path
    combined = CombinedAPIRoute(path, r1 => r2)
    r1.path = ""
    r2.path = ""
    combined::CombinedAPIRoute
end

api_route(r1::APIRoute{:post}, r2::APIRoute{:get}) = api_route(r2, r1)

#==
parent routes
==#

abstract type AbstractParentRoute <: Toolips.AbstractHTTPRoute end

struct ParentRoute{T <: Toolips.AbstractHTTPRoute} <: AbstractParentRoute
    path::String
    page::Function
    pages::Vector{T}
end

function parent_route(f::Function, path::String, provided_routes::Toolips.AbstractHTTPRoute ...)
    routes = [provided_routes ...]
    if length(routes) == 0
        routes = Toolips.AbstractHTTPRoute[]
    end
    ParentRoute{typeof(routes).parameters[1]}(path, f, routes)
end

function route!(c::AbstractConnection, routes::Vector{<:AbstractParentRoute})
    target = get_route(c)
    n_slashes = count('/', target)
    target = split(target, "?")[1]
    if n_slashes < 1
        if ~(target in routes)
            route!(c, routes["404"])
            return
        end
        route!(c, routes[target], target)
    else
        split_target = split(target, "/")
        head = "/" * split_target[2]
        if ~(head in routes)
            route!(c, routes["404"])
            return
        end
        route!(c, routes[head], target)
    end
    nothing::Nothing
end

function route!(c::AbstractConnection, route::ParentRoute, target::AbstractString = route.path)
    if target == route.path
        route.page(c)
    else
        route!(c, route.pages)
    end
    nothing::Nothing
end


export POST, GET, api_route

module APITestServer
using ToolipsAPIRouter
using ToolipsAPIRouter.Toolips

users::Dict{String, Dict} = Dict{String, Dict}("henry" => Dict(:age => 25, :friends => 10))

age_route = (c, username) -> begin
    if haskey(users, username)
        write!(c, users[username][:age])
    else
        write!(c, "user $username not found!")
    end
end

friends_route = (c, username) -> begin
    if haskey(users, username)
        write!(c, users[username][:friends])
    else
        write!(c, "user $username not found!")
    end
end


post_test = (c::AbstractConnection, info::String) -> begin
    write!(c, "information has been sent: $info")
end

post_test2 = (c::AbstractConnection, info::Dict) -> begin
    write!(c, "information has been sent: $(info["x"])")
end

post2 = api_route(post_test2, POST, "/api/age")
postt = api_route(post_test, POST, "/api/posttest")
age = api_route(age_route, GET, "/api/age")
friends = api_route(friends_route, GET, "/api/friends")
adder_r = api_route((c, x::Int64, y::Int64) -> write!(c, x + y), GET, "/api/add")
post_and_age = api_route(age, post2)

API_route = ToolipsAPIRouter.parent_route("/api", friends, adder_r, post_and_age) do c::AbstractConnection
    write!(c, "welcome to the API")
end

main = ToolipsAPIRouter.parent_route("/") do c::AbstractConnection
    write!(c, "my main website")
end

err = ToolipsAPIRouter.parent_route(Toolips.default_404.page, "404")
export err, API_route, main
end

end # module ToolipsAPIRouter

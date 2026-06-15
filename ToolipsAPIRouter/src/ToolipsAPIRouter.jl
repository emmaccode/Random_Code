module ToolipsAPIRouter
using Toolips
using JSON
import Toolips: route!

struct RQType{T} end

const POST = RQType{:post}()
const GET = RQType{:get}()

abstract type AbstractAPIRoute <: Toolips.AbstractHTTPRoute end

struct APIRoute{T} <: AbstractAPIRoute
    path::String
    page::Function
    argnames::Vector{Symbol}
end

struct ParentRoute <: Toolips.AbstractHTTPRoute
    path::String
    pages::Vector{APIRoute}
end

function route!(c::AbstractConnection, route::ParentRoute)
    

end

function route!(c::AbstractConnection, routes::Vector{<:AbstractAPIRoute})::Nothing
    if length(routes) == 1
        route!(c, routes[1])
        return
    end
    target = get_route(c)
    route!(c, routes[target])
    return
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
            JSON.parse!(get_post(c), Dict)
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

adder = (c, x::Int64, y::Int64) -> begin
    write!(c, x + y)
end

post_test = (c::AbstractConnection, info::String) -> begin
    write!(c, "information has been sent: $info")
end

post_test2 = (c::AbstractConnection, info::Dict) -> begin
    write!(c, "information has been sent: $(info["x"])")
end

post2 = api_route(post_test2, POST, "/posttest2")
postt = api_route(post_test, POST, "/posttest")
age = api_route(age_route, GET, "/age")
friends = api_route(friends_route, GET, "/friends")
adder_r = api_route(adder, GET, "/add")
export age, friends, adder_r, postt, post2
end

end # module ToolipsAPIRouter

module CompletelyRandom
import Base: string, *, contains, findall, findfirst, findlast, findprev, findnext
import Base: getindex, setindex!, deleteat!
import Base: open, read, touch, cp, mv
import Base: eachrow, eachcol, length, hcat, vcat, iterate
import Base: show, display
mutable struct File
    path::String
end

string(f::File) = f.path

*(f::File, a::AbstractString) = begin
    f.path = f.path * "/" * string(a)
end

contains(f::File, s::String) = s in split(f.path, "/")

findall(f::Function, file::File) = findall(f, split(file.path, "/"))
findfirst(f::Function, file::File) = findfirst(f, split(file.path, "/"))
findlast(f::Function, file::File) = findlast(f, split(file.path, "/"))
findnext(f::Function, file::File, i::Int64) = findnext(f, split(file.path, "/"), i)
findprev(f::Function, file::File, i::Int64) = findprev(f, split(file.path, "/"), i)

getindex(f::File, i::Int64) = split(f.path, "/")[i]

setindex!(f::File, newuri::String, i::Int64) = begin
    splits = split(f.path, "/")
    splits[i] = newuri
    f.path = join(splits, "/")
end

function deleteat!(f::File, i::Int64)
    splits = split(f.path, "/")
    deleteat!(splits, i)
    f.path = join(splits, "/")
end

open(f::Function, file::File, args ...; keyargs ...) = open(f, file.path, args ...; keyargs ...)

read(f::File, args ...; keyargs ...) = read(f.path, args ...; keyargs)

touch(f::File) = touch(f.path)

cp(f::File, s::AbstractString) = cp(f::File, string(s))

mv(f::File, s::AbstractString) = mv(f::File, string(s))

show(io::IO, f::File) = begin
    println(f.path)
end

mutable struct LabeledMatrix{T}
    mat::Matrix{T}
    labels::Vector{String}
    function LabeledMatrix(pairs::Pair ...)
        T = typeof(pairs[1][2]).parameters[1]
        basemat::AbstractArray = pairs[1][2]
        if length(pairs) > 1
            [basemat = hcat(basemat, newvec[2]) for newvec in pairs[2:length(pairs)]]
        end
        new{T}(basemat, [p[1] for p in pairs])::LabeledMatrix{T}
    end
end

getindex(lm::LabeledMatrix{<:Any}, args::Any ...) = getindex(lm.mat, args ...)

getindex(lm::LabeledMatrix{<:Any}, col::String) = begin
    axis_col = findfirst(s::String -> s == col, lm.labels)
    eachcol(lm.mat)[axis_col]
end

eachrow(lm::LabeledMatrix{<:Any}) = eachrow(lm.mat)
eachcol(lm::LabeledMatrix{<:Any}) = eachcol(lm.mat)
length(lm::LabeledMatrix{<:Any}) = length(lm.mat)
hcat(lm::LabeledMatrix{<:Any}, vecs::AbstractVector ...) = hcat(lm.mat, vecs ...)
vcat(lm::LabeledMatrix{<:Any}, vecs::AbstractVector ...) = vcat(lm.mat, vecs ...)

function hcat!(lm::LabeledMatrix{<:Any}, p::Pair{String, <:AbstractVector})
    lm.mat = hcat(lm.mat, p[2])
    push!(lm.labels, p[1])
    nothing
end

iterate(lm::CompletelyRandom.LabeledMatrix, x ...) = iterate(lm.mat, x ...)

show(io::IO, lm::LabeledMatrix) = begin
    println(join(lm.labels, " | "))
    [println(join(vals, " | ")) for vals in eachrow(lm)]
end

export LabeledMatrix, File
export hcat!
end # module CompletelyRandom

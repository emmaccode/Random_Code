module FileInterpolators
import Base: Vector

struct File{T <: Any}
    uri::String
    File(uri::String) = begin
        uri_splits = split(uri, ".")
        if length(uri_splits) == 1
            new{:unknown}(uri)::File
        end
        ending = join(uri_splits[2:length(uri_splits)])
        new{Symbol(ending)}(uri)::File
    end
end

Vector(f::File) = split(f.uri, "/")

function interpolate(f::File{:md}; args ...)
    raw_file::String = read(f.uri, String)
    [begin
        key = value[1]
        val::String = string(value[2])
        positions = findall("`$key`", raw_file)
        [begin 
          raw_file = raw_file[1:minimum(position) - 1] * val * raw_file[maximum(position) + 1:length(raw_file)]
        end for position in positions]
    end for value in args]
    raw_file::String
end

function interpolate(f::File{<:Any}; args ...)
    raw_file::String = read(f.uri, String)
    [begin
        key = value[1]
        val::String = string(value[2])
        positions = findall("%$key", raw_file)
        [begin 
          raw_file = raw_file[1:minimum(position) - 1] * val * raw_file[maximum(position) + 1:length(raw_file)]
        end for position in positions]
    end for value in args]
    raw_file::String
end

end # module FileInterplolators
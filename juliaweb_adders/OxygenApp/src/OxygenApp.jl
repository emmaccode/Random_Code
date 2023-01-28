using Oxygen

@get "/{x}/{y}" add(req, x::Int64, y::Int64) = x + y

serve()

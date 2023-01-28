using Genie.Router

route("/") do
  x = string(params(:x, 5))
  y = string(params(:y, 2))
  x = parse(Int64, x)
  y = parse(Int64, y)
  return(x + y)
end

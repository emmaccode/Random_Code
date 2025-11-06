using Pkg; Pkg.activate(".")
using Revise
using Toolips
using RPCSample
toolips_process = start!(RPCSample, "192.168.1.20":8000)

using Pkg; Pkg.activate(".")
using Toolips
using Revise
using ToolipsApp

IP = "127.0.0.1"
PORT = 8000
ToolipsAppServer = ToolipsApp.start(IP, PORT)

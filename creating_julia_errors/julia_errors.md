```julia
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.9.0 (2023-05-07)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> import Base: showerror

julia> meths = methods(showerror)
# 51 methods for generic function "showerror" from Base:
  [1] showerror(io::IO, ex::ErrorException)
     @ errorshow.jl:143
  [2] showerror(io::IO, ex::Test.FallbackTestSetException, bt; backtrace)
     @ Test ~/julia-1.9.0/share/julia/stdlib/v1.9/Test/src/Test.jl:951
  [3] showerror(io::IO, re::Distributed.RemoteException)
     @ Distributed ~/julia-1.9.0/share/julia/stdlib/v1.9/Distributed/src/process_messages.jl:62
  [4] showerror(io::IO, ex::MethodError)
     @ errorshow.jl:224
  [5] showerror(io::IO, ex::UndefVarError)
     @ errorshow.jl:162
  [6] showerror(io::IO, ex::AssertionError)
     @ errorshow.jl:156
  [7] showerror(io::IO, ex::BoundsError)
     @ errorshow.jl:39
  [8] showerror(io::IO, ::EOFError)
     @ errorshow.jl:142
  [9] showerror(io::IO, p::Base.PaddingError)
     @ reinterpretarray.jl:670
 [10] showerror(io::IO, err::ProcessFailedException)
     @ process.jl:551
 [11] showerror(io::IO, err::Base.TOML.ParserError)
     @ Base.TOML toml_parser.jl:321
 [12] showerror(io::IO, e::Distributed.LaunchWorkerError)
     @ Distributed ~/julia-1.9.0/share/julia/stdlib/v1.9/Distributed/src/cluster.jl:299
 [13] showerror(io::IO, exc::StringIndexError)
     @ strings/string.jl:14
 [14] showerror(io::IO, ex::LoadError)
     @ errorshow.jl:99
 [15] showerror(io::IO, ex::LoadError, bt; backtrace)
     @ errorshow.jl:94
 [16] showerror(io::IO, ex::OverflowError)
     @ errorshow.jl:157
 [17] showerror(io::IO, err::Pkg.Types.PkgError)
     @ Pkg.Types ~/julia-1.9.0/share/julia/stdlib/v1.9/Pkg/src/Types.jl:70
 [18] showerror(io::IO, pkgerr::Pkg.Resolve.ResolverError)
     @ Pkg.Resolve ~/julia-1.9.0/share/julia/stdlib/v1.9/Pkg/src/Resolve/Resolve.jl:42
 [19] showerror(io::IO, err::Pkg.LazilyInitializedFields.AlreadyInitializedException)
     @ Pkg.LazilyInitializedFields ~/julia-1.9.0/share/julia/stdlib/v1.9/Pkg/ext/LazilyInitializedFields/LazilyInitializedFields.jl:107
 [20] showerror(io::IO, ex::InitError)
     @ errorshow.jl:106
 [21] showerror(io::IO, ex::InitError, bt; backtrace)
     @ errorshow.jl:101
 [22] showerror(io::IO, ex::CompositeException)
     @ task.jl:58
 [23] showerror(io::IO, err::Printf.InvalidFormatStringError)
     @ Printf ~/julia-1.9.0/share/julia/stdlib/v1.9/Printf/src/Printf.jl:91
 [24] showerror(io::IO, ex::LinearAlgebra.ZeroPivotException)
     @ LinearAlgebra ~/julia-1.9.0/share/julia/stdlib/v1.9/LinearAlgebra/src/exceptions.jl:60
 [25] showerror(io::IO, ex::UndefKeywordError)
     @ errorshow.jl:159
 [26] showerror(io::IO, ex::KeyError)
     @ errorshow.jl:150
 [27] showerror(io::IO, ex::DomainError)
     @ errorshow.jl:108
 [28] showerror(io::IO, err::Pkg.LazilyInitializedFields.UninitializedFieldException)
     @ Pkg.LazilyInitializedFields ~/julia-1.9.0/share/julia/stdlib/v1.9/Pkg/ext/LazilyInitializedFields/LazilyInitializedFields.jl:96
 [29] showerror(io::IO, ce::CapturedException)
     @ task.jl:24
 [30] showerror(io::IO, err::Pkg.LazilyInitializedFields.NonLazyFieldException)
     @ Pkg.LazilyInitializedFields ~/julia-1.9.0/share/julia/stdlib/v1.9/Pkg/ext/LazilyInitializedFields/LazilyInitializedFields.jl:88
 [31] showerror(io::IO, ::StackOverflowError)
     @ errorshow.jl:140
 [32] showerror(io::IO, ex::DimensionMismatch)
     @ errorshow.jl:155
 [33] showerror(io::IO, ex::ArgumentError)
     @ errorshow.jl:154
 [34] showerror(io::IO, ex::SystemError)
     @ errorshow.jl:124
 [35] showerror(io::IO, ex::TaskFailedException)
     @ task.jl:80
 [36] showerror(io::IO, ex::TaskFailedException, bt; backtrace)
     @ task.jl:80
 [37] showerror(io::IO, ex::Test.TestSetException, bt; backtrace)
     @ Test ~/julia-1.9.0/share/julia/stdlib/v1.9/Test/src/Test.jl:933
 [38] showerror(io::IO, ex::LinearAlgebra.PosDefException)
     @ LinearAlgebra ~/julia-1.9.0/share/julia/stdlib/v1.9/LinearAlgebra/src/exceptions.jl:34
 [39] showerror(io::IO, e::Base.IOError)
     @ libuv.jl:85
 [40] showerror(io::IO, ex::Base.ScheduledAfterSyncException)
     @ task.jl:380
 [41] showerror(io::IO, ex::InvalidStateException)
     @ channels.jl:305
 [42] showerror(io::IO, ex::CanonicalIndexError)
     @ errorshow.jl:174
 [43] showerror(io::IO, ::DivideError)
     @ errorshow.jl:139
 [44] showerror(io::IO, ex::TypeError)
     @ errorshow.jl:62
 [45] showerror(io::IO, ex::InterruptException)
     @ errorshow.jl:153
 [46] showerror(io::IO, err::Downloads.RequestError)
     @ Downloads ~/julia-1.9.0/share/julia/stdlib/v1.9/Downloads/src/Downloads.jl:134
 [47] showerror(io::IO, ex::InexactError)
     @ errorshow.jl:167
 [48] showerror(io::IO, ::UndefRefError)
     @ errorshow.jl:141
 [49] showerror(io::IO, ex::MissingException)
     @ missing.jl:18
 [50] showerror(io::IO, ex)
     @ errorshow.jl:30
 [51] showerror(io::IO, ex, bt; backtrace)
     @ errorshow.jl:86

julia> Base.delete_method(meths[8])

julia> function showerror(io::IO, e::EOFError)
          println(io, "hi!")
       end
showerror (generic function with 51 methods)

julia> throw(EOFError())
ERROR: hi!
```

Stacktrace:
 [1] top-level scope
   @ REPL[5]:1


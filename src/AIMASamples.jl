module AIMAsamples

try
    if Pkg.installed("AIMACore") == nothing
        Pkg.add("AIMACore")
    end
catch
    Pkg.clone("https://github.com/sambitdash/AIMACore.jl")
end

include("VacuumEnvironment.jl")
include("Romania.jl")

end # module

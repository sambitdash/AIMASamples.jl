module aimasamples

#=
Package core has all the AIMA algorithms preserved in a verbatim manner.
Has no assumption of any datastructure as that may affect people interested
in creating their own extensions may have to align their datastructure to the
interface defined.
=#
module core
include("errors.jl")
include("agents.jl")
end

#=
Sample applications have their own module spaces so that they do not need any
module encapsulation in this file.
=#

include("VacuumEnvironment.jl")

end # module

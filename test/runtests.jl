using aimasamples.Vacuum
using Base.Test

# write your own tests here
@test RunTableDrivenVacuumAgent()==RunTableDrivenVacuumAgentResult
@test RunSimpleReflexVacuumAgent()==RunSimpleReflexVacuumAgentResult
@test RunReflexVacuumAgent()==RunReflexVacuumAgentResult
@test RunModelBasedVacuumAgent()==RunModelBasedVacuumAgentResult

using aimasamples.Vacuum
using Base.Test

# write your own tests here
@testset "Vacuum" begin
  @test RunTableDrivenVacuumAgent()==RunTableDrivenVacuumAgentResult
  @test RunSimpleReflexVacuumAgent()==RunSimpleReflexVacuumAgentResult
  @test RunReflexVacuumAgent()==RunReflexVacuumAgentResult
  @test RunModelBasedVacuumAgent()==RunModelBasedVacuumAgentResult
end

using aimasamples.Romania

@testset "Romania" begin
  @test solveRomanianMapProblemBFS()==solveRomanianMapProblemResultBFS
  @test solveRomanianMapProblemUCS()==solveRomanianMapProblemResultMinCost
end

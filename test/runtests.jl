using Base.Test

using AIMASamples.Vacuum
@testset "Vacuum" begin
    @test RunTableDrivenVacuumAgent() == RunTableDrivenVacuumAgentResult
    @test RunSimpleReflexVacuumAgent() == RunSimpleReflexVacuumAgentResult
    @test RunReflexVacuumAgent() == RunReflexVacuumAgentResult
    @test RunModelBasedVacuumAgent() == RunModelBasedVacuumAgentResult
end

using AIMASamples.Romania
@testset "Romania" begin
    @test solveRomanianMapProblemBFS() == solveRomanianMapProblemResultBFS
    @test solveRomanianMapProblemUCS() == solveRomanianMapProblemResultMinCost
end

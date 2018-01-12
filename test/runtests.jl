using Base.Test

using AIMASamples.Vacuum
@testset "Vacuum" begin
    @test RunTableDrivenVacuumAgent()  == RunTableDrivenVacuumAgentResult
    @test RunSimpleReflexVacuumAgent() == RunSimpleReflexVacuumAgentResult
    @test RunReflexVacuumAgent()       == RunReflexVacuumAgentResult
    @test RunModelBasedVacuumAgent()   == RunModelBasedVacuumAgentResult
end

using AIMASamples.Romania
@testset "Romania" begin
    @test solveRomanianMapProblemBFS() == solveRomanianMapProblemResultBFS
    @test solveRomanianMapProblemUCS() == solveRomanianMapProblemResultMinCost
    @test solveRomanianMapProblemDLS() == solveRomanianMapProblemResultDLS
    @test solveRomanianMapProblemIDS() == solveRomanianMapProblemResultIDS
    @test solveRomanianMapProblemGSB() == solveRomanianMapProblemResultGSB
    @test solveRomanianMapProblemGSD() == solveRomanianMapProblemResultGSD
    @test solveRomanianMapProblemGSU() == solveRomanianMapProblemResultGSU
    @test solveRomanianMapProblemGSAS() == solveRomanianMapProblemResultGSAS
    @test solveRomanianMapProblemGSBF() == solveRomanianMapProblemResultGSBF
    @test solveRomanianMapProblemRBF() == solveRomanianMapProblemResultRBF
end

using AIMASamples.SlideBlock
@testset "SlideBlock" begin
    @test length(solveSlideBlockProblemRBFS()) == 27
    @test length(solveSlideBlockProblemGSU())  == 27
    @test length(solveSlideBlockProblemGSBF()) != 27
    @test length(solveSlideBlockProblemGSBF2())!= 27
    @test length(solveSlideBlockProblemGSAS()) == 27
    @test length(solveSlideBlockProblemGSAS2())== 27
end

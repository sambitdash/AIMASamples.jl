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
    @test begin
        ret = solveSlideBlockProblemRBFS()
        println("$(ret[1]) to\n\n$(ret[end])")   #Added for coverage only
        length(ret) == 27
    end
    @test length(solveSlideBlockProblemGSU())  == 27
    @test length(solveSlideBlockProblemGSBF()) == 71
    @test length(solveSlideBlockProblemGSBF2())== 195
    @test length(solveSlideBlockProblemGSAS()) == 27
    @test length(solveSlideBlockProblemGSAS2())== 27
end

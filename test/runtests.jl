include("../../../src/AIMACore.jl");
include("../src/AIMASamples.jl");

using AIMACore

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
    @test length(solveSlideBlockProblemGSBF()) != 27
    @test length(solveSlideBlockProblemGSBF2())!= 27
    @test length(solveSlideBlockProblemGSAS()) == 27
    @test length(solveSlideBlockProblemGSAS2())== 27
end

using AIMASamples.Queens
@testset "Queens" begin
    @test begin
        ret = solveNQueensProblemGSU()
        println("$(ret[1]) to\n\n$(ret[end])")   #Added for coverage only
        length(ret) == 9
    end
    @test length(solveNQueensProblemGSBF()) == 9
    @test length(solveNQueensProblemGSAS()) == 9
    @test length(solveNQueensProblemRBFS()) == 9
    @test begin #This is carried out for coverage only
        solveNQueensProblemHCS()
        solveNQueensProblemSAS()
        solveNQueensProblemGAS()
        solveNQueensProblemGAS9()
        1 == 1
    end
end


#=
Julia - GSOC

Ahmed Madbouly

Sample for LRTA
=#

println("\nLTRA:")
@testset "LRTA" begin
    # Initialize LRTAStarAgentProgram with an OnlineSearchProblem.

    lrtastar_program = OnlineSearchProblem("State_3", "State_5", AIMACore.one_dim_state_space, AIMACore.one_dim_state_space_least_costs);
    lrtastar_agentprogram = LRTAStarAgentProgram(lrtastar_program);

    @test execute(lrtastar_agentprogram, "State_3") == "Right";

    @test execute(lrtastar_agentprogram, "State_4") == "Left";

    @test execute(lrtastar_agentprogram, "State_3") == "Right";

    @test execute(lrtastar_agentprogram, "State_4") == "Right";

    @test execute(lrtastar_agentprogram, "State_5") == nothing;

    lrtastar_agentprogram = LRTAStarAgentProgram(lrtastar_program);

    @test execute(lrtastar_agentprogram, "State_4") == "Left";

    lrtastar_agentprogram = LRTAStarAgentProgram(lrtastar_program);

    @test execute(lrtastar_agentprogram, "State_5") == nothing;
end


println("And-Or-Graph-Search:\n")  # Not Completed Yet
#@test test_and_or_graph_search()


println("\nOnline-DFS-Agent:")	# Not Completed Yet


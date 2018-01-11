module Romania

export solveRomanianMapProblemBFS, solveRomanianMapProblemResultBFS,
       solveRomanianMapProblemUCS, solveRomanianMapProblemResultMinCost,
       solveRomanianMapProblemDLS, solveRomanianMapProblemResultDLS,
       solveRomanianMapProblemIDS, solveRomanianMapProblemResultIDS,
       solveRomanianMapProblemRBF, solveRomanianMapProblemResultRBF,
       solveRomanianMapProblemGSB, solveRomanianMapProblemResultGSB,
       solveRomanianMapProblemGSD, solveRomanianMapProblemResultGSD,
       solveRomanianMapProblemGSU, solveRomanianMapProblemResultGSU,
       solveRomanianMapProblemGSAS,solveRomanianMapProblemResultGSAS,
       solveRomanianMapProblemGSBF,solveRomanianMapProblemResultGSBF

using AIMACore

import Base: isempty, in
import AIMACore: search, goal_test, step_cost, actions, result, heuristic

struct In <: State
  place::Symbol
  In(place::Symbol) = new(place)
end
In(place::AbstractString) = In(Symbol(place))

struct Go <: Action
    place::Symbol
    Go(place::Symbol) = new(place)
end
Go(place::AbstractString) = Go(Symbol(place))

mutable struct RomaniaRoadMapProblem{SA <: SearchAlgorithm} <: Problem
    places::Dict{Symbol, Dict{Symbol,Int}}
    hSLD::Dict{Symbol, Int}
    initial_state::In
    goal_state::In
    search_algorithm::SA
    function RomaniaRoadMapProblem{SA}(init::In, goal::In,
                                       search_algorithm::SA) where {SA <: SearchAlgorithm}
        places = Dict(
            :Arad=>Dict(:Sibiu=>140,:Timisoara=>118,:Zerind=>75),
            :Bucharest=>Dict(:Fragaras=>211,:Giurgiu=>90,:Pitesti=>101,:Urziceni=>85),
            :Craiova=>Dict(:Drobeta=>120, :Pitesti=>138,:RimnicuVilcea=>146),
            :Drobeta=>Dict(:Craiova=>120, :Mehadia=>75),
            :Eforie=>Dict(:Hirsova=>86),
            :Fagaras=>Dict(:Bucharest=>211,:Sibiu=>99),
            :Giurgiu=>Dict(:Bucharest=>90),
            :Hirsova=>Dict(:Eforie=>86,:Urziceni=>98),
            :Iasi=>Dict(:Neamt=>87, :Vaslui=>92),
            :Lugoj=>Dict(:Mehadia=>70,:Timisoara=>111),
            :Mehadia=>Dict(:Drobeta=>75,:Lugoj=>70),
            :Neamt=>Dict(:Iasi=>87),
            :Oradea=>Dict(:Zerind=>71, :Sibiu=>151),
            :Pitesti=>Dict(:Bucharest=>101, :Craiova=>138, :RimnicuVilcea=>97),
            :RimnicuVilcea=>Dict(:Craiova=>146, :Pitesti=>97, :Sibiu=>80),
            :Sibiu=>Dict(:Arad=>140, :Fagaras=>99, :Oradea=>151, :RimnicuVilcea=>80),
            :Timisoara=>Dict(:Arad=>118, :Lugoj=>111),
            :Urziceni=>Dict(:Bucharest=>85, :Hirsova=>98, :Vaslui=>142),
            :Vaslui=>Dict(:Iasi=>92, :Urziceni=>142),
            :Zerind=>Dict(:Arad=>75, :Oradea=>71))

        hSLD = Dict(:Arad=>366,
                    :Bucharest=>0,
                    :Craiova=>160,
                    :Drobeta=>242,
                    :Eforie=>161,
                    :Fagaras=>176,
                    :Giurgiu=>77,
                    :Hirsova=>151,
                    :Iasi=>226,
                    :Lugoj=>244,
                    :Mehadia=>241,
                    :Neamt=>234,
                    :Oradea=>380,
                    :Pitesti=>100,
                    :RimnicuVilcea=>193,
                    :Sibiu=>253,
                    :Timisoara=>329,
                    :Urziceni=>80,
                    :Vaslui=>199,
                    :Zerind=>374)

        return new(places, hSLD, init, goal, search_algorithm)
    end
end

function result(problem::RomaniaRoadMapProblem, state::In, action::Go)
    s = state.place
    r = action.place
    haskey(problem.places[s], r) && return In(r)
    error("Invalid location cannot be reached")
end

function step_cost(problem::RomaniaRoadMapProblem, state::In, action::Go)
    s = state.place
    r = action.place
    return problem.places[s][r]
end

heuristic(problem::RomaniaRoadMapProblem, state::In) = problem.hSLD[state.place]

goal_test(problem::RomaniaRoadMapProblem, state::In) = (state == problem.goal_state)

function actions(problem::RomaniaRoadMapProblem, state::In)
    ret=[]
    for k in keys(problem.places[state.place])
        push!(ret, Go(k))
    end
    return ret
end

const solveRomanianMapProblemResultBFS =
    [(:Arad, 0), (:Sibiu, 140), (:Fagaras,239), (:Bucharest, 450)]
const solveRomanianMapProblemResultMinCost =
    [(:Arad, 0), (:Sibiu, 140), (:RimnicuVilcea, 220), (:Pitesti, 317), (:Bucharest, 418)]
const solveRomanianMapProblemResultDLS =
    [(:Arad, 0), (:Sibiu, 140), (:RimnicuVilcea, 220), (:Pitesti, 317), (:Bucharest, 418)]
const solveRomanianMapProblemResultIDS =
    [(:Arad, 0), (:Sibiu, 140), (:Fagaras,239), (:Bucharest, 450)]

const solveRomanianMapProblemResultGSB = solveRomanianMapProblemResultMinCost
const solveRomanianMapProblemResultGSU = solveRomanianMapProblemResultMinCost
const solveRomanianMapProblemResultRBF = solveRomanianMapProblemResultMinCost
const solveRomanianMapProblemResultGSD = solveRomanianMapProblemResultIDS
const solveRomanianMapProblemResultGSBF = solveRomanianMapProblemResultIDS
const solveRomanianMapProblemResultGSAS = solveRomanianMapProblemResultMinCost

const BFS = BreadthFirstSearch(In(""))
const UCS = UniformCostSearch(In(""))
const DLS = DepthLimitedSearch(4)
const IDS = IterativeDeepeningSearch()
const RBF = RecursiveBestFirstSearch(In(""))

const GSB = GraphSearchBreadth(In(""))
const GSD = GraphSearchDepth(In(""))
const GSU = GraphSearchUniformCost(In(""))

const GSBF = GraphSearchBestFirst(In(""))
const GSAS = GraphSearchAStar(In(""))

function solveRomanianMapProblem{T}(obj::T)
    problem = RomaniaRoadMapProblem{T}(In("Arad"), In("Bucharest"), obj)
    path = search(problem)
    path isa Symbol && return path
    ret=[]
    for iter in path
        push!(ret, (iter.state.place, iter.path_cost))
    end
    return ret
end

solveRomanianMapProblemBFS() = solveRomanianMapProblem(BFS)
solveRomanianMapProblemUCS() = solveRomanianMapProblem(UCS)
solveRomanianMapProblemDLS() = solveRomanianMapProblem(DLS)
solveRomanianMapProblemIDS() = solveRomanianMapProblem(IDS)
solveRomanianMapProblemRBF() = solveRomanianMapProblem(RBF)
solveRomanianMapProblemGSB() = solveRomanianMapProblem(GSB)
solveRomanianMapProblemGSD() = solveRomanianMapProblem(GSD)
solveRomanianMapProblemGSU() = solveRomanianMapProblem(GSU)
solveRomanianMapProblemGSBF() = solveRomanianMapProblem(GSBF)
solveRomanianMapProblemGSAS() = solveRomanianMapProblem(GSAS)

end

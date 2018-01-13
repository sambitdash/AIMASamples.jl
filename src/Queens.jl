module Queens

export  solveNQueensProblemRBFS,
        solveNQueensProblemGSU,
        solveNQueensProblemGSBF,
        solveNQueensProblemGSAS

using AIMACore

import AIMACore: search, goal_test, step_cost, actions, result, heuristic
import Base: ==, show, convert, hash

const E_INVALID_INPUT_LENGTH = "The input parameter is of a wrong length"
const E_INVALID_INPUT = "The input parameter is invalid"
const E_INVALID_STATE = "The state is invalid"
const E_INVALID_ACTION = "The action is invalid"

const SIZE = 8

struct Grid{T} <: State
    qloc::Vector{Tuple{Int, Int}}
end

# This heuristic is not relevant as this is the same for every step
h{T}(g::Grid{T}) = T - length(g.qloc)

Grid(qloc::Vector{Tuple{Int, Int}}, T) = Grid{T}(qloc)

Grid(T::Int) = Grid(Vector{Tuple{Int, Int}}(), T)

function convert(::Type{BitArray{2}}, g::Grid{T}) where T
    m = BitArray{2}(T, T)
    for l in g.qloc
        m[l[2],l[1]] = true
    end
    return m
end

==(g1::Grid, g2::Grid) = hash(g1) == hash(g2)

hash(g::Grid{T}, h::UInt) where T = sum([t[1]*(T+1)^t[2] for t in g.qloc])

function show(io::IO, g::Grid{T}) where T
    m = BitArray{2}(g)
    a = [ m[i,j] ? 'Q' : ' ' for i=1:T,j=1:T]
    for j = 1:T-1
        show(io, a[j,:])
        println(io, "")
    end
    show(io, a[T,:])
end

struct Place <: Action
    location::Tuple{Int,Int}
end

mutable struct NQueensProblem{SA <: SearchAlgorithm, T} <: Problem
    initial_state::Grid{T}
    search_algorithm::SA
    h::Function
end

function result(problem::NQueensProblem,
                state::Grid{T}, action::Place) where T
    qloc = copy(state.qloc)
    push!(qloc, action.location)
    return Grid(qloc, T)
end

step_cost(problem::NQueensProblem, state::Grid, action::Place) = 1

heuristic(problem::NQueensProblem, state::Grid) = problem.h(state)

goal_test(problem::NQueensProblem, state::Grid{T}) where T = length(state.qloc) == T

cannot_place(x, y, i, j) = x == i || y == j || x + j == y + i || x + y == i + j

cannot_place(state::Grid, i, j) = any(x->cannot_place(x[1], x[2], i, j), state.qloc)

actions{T}(problem::NQueensProblem, state::Grid{T}) =
    Place.([(i, j) for i=1:T for j=1:T if !cannot_place(state, i, j)])

function solveNQueensProblem(obj::SA, h::Function) where {SA <: SearchAlgorithm}
    problem = NQueensProblem(Grid(SIZE), obj, h)
    path = search(problem)
    path isa Symbol && return path
    ret=[]
    count = 0
    for iter in path
        push!(ret, iter.state)
    end
    return ret
end

const GSD = GraphSearchDepth(Grid(SIZE))
const GSU = GraphSearchUniformCost(Grid(SIZE))
const GSBF = GraphSearchBestFirst(Grid(SIZE))
const GSAS = GraphSearchAStar(Grid(SIZE))
const RBFS = RecursiveBestFirstSearch(Grid(SIZE))

solveNQueensProblemGSU() = solveNQueensProblem(GSU, h)
solveNQueensProblemGSBF() = solveNQueensProblem(GSBF, h)
solveNQueensProblemGSAS() = solveNQueensProblem(GSAS, h)
solveNQueensProblemRBFS() = solveNQueensProblem(RBFS, h)

end

module SlideBlock

export  solveSlideBlockProblemRBFS,
        solveSlideBlockProblemGSU,
        solveSlideBlockProblemGSBF,
        solveSlideBlockProblemGSBF2,
        solveSlideBlockProblemGSAS,
        solveSlideBlockProblemGSAS2

using AIMACore

import AIMACore: search, goal_test, step_cost, actions, result, heuristic
import Base: ==, show, hash

const E_INVALID_INPUT_LENGTH = "The input parameter is of a wrong length"
const E_INVALID_INPUT = "The input parameter is invalid"
const E_INVALID_STATE = "The state is invalid"
const E_INVALID_ACTION = "The action is invalid"

XY(n, N) = mod(n, N) + 1, mod(div(n,N), N) + 1

dist(t1, t2)    = abs(t1[1] - t2[1]) + abs(t1[2] - t2[2])
dist(n1, n2, N) = dist(XY(n1, N), XY(n2, N))

struct Grid{T} <: State
    loc::Vector{Tuple{Int, Int}}
    h::UInt
end

function Grid{T}(v::Vector{Int}) where T
    N = T*T
    @assert length(v) == N E_INVALID_INPUT
    loc = Vector{Tuple{Int, Int}}(undef, N)
    sum = UInt(0)
    for i = 1:N
        n = v[i]
        @assert n < N E_INVALID_INPUT
        loc[n+1] = XY(i-1, T)
        sum += UInt(n)
        sum *= UInt(N)
    end
    return Grid{T}(loc, sum)
end

Grid(T::Int) = Grid{T}([x for x = 0:T*T-1])

dist(g1::Grid{T}, g2::Grid{T}) where T = sum(dist.(g1.loc, g2.loc))
h2(g1::Grid{T}, g2::Grid{T})   where T = count(g1.loc .!= g2.loc)

==(g1::Grid, g2::Grid) = hash(g1) == hash(g2)

hash(g::Grid, h::UInt) = xor(g.h, h)

function convert(::Type{Matrix{Int}}, g::Grid{T}) where T
    N = T*T
    m = Matrix{Int}(undef, T, T)
    for i = 1:N
        t = g.loc[i]
        m[t[2], t[1]] = i - 1
    end
    return m
end

Matrix{Int}(g::Grid{T}) where T = convert(Matrix{Int}, g)

function show(io::IO, g::Grid{T}) where T
    m = Matrix{Int}(g)
    for j = 1:T-1
        show(io, m[j,:])
        println(io, "")
    end
    show(io, m[T,:])
end

struct Move <: Action
    d::Symbol
end
Move(d::AbstractString) = Move(Symbol(d))

mutable struct SlideBlockProblem{SA <: SearchAlgorithm, T} <: Problem
    initial_state::Grid{T}
    goal_state::Grid{T}
    search_algorithm::SA
    h::Function
end

SlideBlockProblem(init::Grid{T},
                  sa::SA, fh::Function) where {SA <: SearchAlgorithm, T} =
    SlideBlockProblem(init, Grid(T), sa, fh)

function result(problem::SlideBlockProblem{SA,T},
                state::Grid{T}, action::Move) where {SA <: SearchAlgorithm, T}
    N = UInt(T*T)
    loc = deepcopy(state.loc)
    x1, y1 = loc[1]
    xn, yn = action.d == :left  ? (x1 - 1, y1) :
             action.d == :right ? (x1 + 1, y1) :
             action.d == :up    ? (x1, y1 - 1) :
             action.d == :down  ? (x1, y1 + 1) :
             throw(ErrorException(E_INVALID_ACTION))

    i = findfirst(x-> x == (xn,yn), loc)
    if i != 0 && 1 <= xn <= T && 1 <= yn <= T
        loc[1] = (xn, yn)
        loc[i] = (x1, y1)
        #Readjusting the hash
        hn = UInt(i-1)*(N ^ (N-UInt(xn-1+T*(yn-1))))
        h1 = UInt(i-1)*(N ^ (N-UInt(x1-1+T*(y1-1))))
        h = state.h - hn + h1
        return Grid{T}(loc, h)
    else
        throw(ErrorException(E_INVALID_STATE))
    end
end

step_cost(problem::SlideBlockProblem, state::Grid, action::Move) = 1

heuristic(problem::SlideBlockProblem, state::Grid) = problem.h(state, problem.goal_state)

goal_test(problem::SlideBlockProblem, state::Grid) = (state == problem.goal_state)

function actions(problem::SlideBlockProblem, state::Grid{T}) where T
    ret=[]
    x1, y1 = state.loc[1]
    x1 != 1 && push!(ret, Move(:left))
    x1 != T && push!(ret, Move(:right))
    y1 != 1 && push!(ret, Move(:up))
    y1 != T && push!(ret, Move(:down))
    return ret
end

function solveSlideBlockProblem(obj::SA, h::Function) where SA
    vinit = [7, 2, 4, 5, 0, 6, 8, 3, 1]
    problem = SlideBlockProblem(Grid{3}(vinit), obj, h)
    path = search(problem)
    path isa Symbol && return path
    ret=[]
    count = 0
    for iter in path
        push!(ret, iter.state)
    end
    return ret
end

GSD = GraphSearchDepth(Grid(3))
GSU = GraphSearchUniformCost(Grid(3))
GSBF = GraphSearchBestFirst(Grid(3))
GSAS = GraphSearchAStar(Grid(3))
RBFS = RecursiveBestFirstSearch(Grid(3))

solveSlideBlockProblemGSU() = solveSlideBlockProblem(GSU, dist)
solveSlideBlockProblemGSBF() = solveSlideBlockProblem(GSBF, dist)
solveSlideBlockProblemGSAS() = solveSlideBlockProblem(GSAS, dist)
solveSlideBlockProblemRBFS() = solveSlideBlockProblem(RBFS, dist)
solveSlideBlockProblemGSAS2() = solveSlideBlockProblem(GSAS, h2)
solveSlideBlockProblemGSBF2() = solveSlideBlockProblem(GSBF, h2)

end

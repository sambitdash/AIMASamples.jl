module Vacuum
export RunTableDrivenVacuumAgent, RunTableDrivenVacuumAgentResult,
       RunSimpleReflexVacuumAgent, RunSimpleReflexVacuumAgentResult,
       RunReflexVacuumAgent, RunReflexVacuumAgentResult,
       RunModelBasedVacuumAgent, RunModelBasedVacuumAgentResult

using Compat
using AIMACore

import AIMACore: execute, interpret_input, rule_match, update_state, lookup

#=
Concrete instantiation of VacuumEnvironment using the models described in

AIMA 3e Chapter 2.
=#

"""
*VacuumEnvironment* has 2 locations:

1. loc_A
2. loc_B

adjacent to each other. loc_B to the *Right* of loc_A. This shall mean loc_A is
on the *Left* of loc_B.

A vacuum cleaner can sense *Dirt* is the location it's in.

If *Dirt* is found it will *Suck* the *Dirt* and *Clean* the location.

The *Environment* is still abstract as it gets expressed through its components.
"""
@compat abstract type VacuumEnvironment <: Environment end

"""
In a *VacuumEnvironment* a robot can only read where it's current location is
and whether the location has *Dirt* or is *Clean*.

There are 4 possible *Percept*.

(loc_A, Dirty)
(loc_A, Clean)
(loc_B, Dirty)
(loc_B, Clean)
"""
# Making immutable ensures additional hash function overloading not
# needed for Julia Dict.
struct VacuumPercept <: Percept
    location_status::Tuple{Symbol, Symbol}
    VacuumPercept(loc::AbstractString, cstate::AbstractString)=
        new((Symbol(loc), Symbol(cstate)))
end

const PAC = VacuumPercept("loc_A", "Clean")
const PAD = VacuumPercept("loc_A", "Dirty")
const PBC = VacuumPercept("loc_B", "Clean")
const PBD = VacuumPercept("loc_B", "Dirty")

"""
The vacuum cleaner can do the following actions.

Move from loc_A to loc_B --> Right
Move from loc_B to loc_A --> Left
If Dirty, Suck the Dirt  --> Suck
"""
# Making immutable ensures additional hash function overloading not
# needed for Julia Dict.
struct VacuumAction <: Action
    sym::Symbol
    VacuumAction(str::AbstractString) = new(Symbol(str))
end

const Action_Left = VacuumAction("Left")
const Action_Right = VacuumAction("Right")
const Action_Suck = VacuumAction("Suck")

"""
Concrete implementation for the Vacuum Agent using the
*TableDrivenAgentProgram*
"""
mutable struct TableDrivenVacuumAgentProgram <: TableDrivenAgentProgram
    table::Dict{Vector{VacuumPercept}, Action}
    percepts::Vector{VacuumPercept}

    function TableDrivenVacuumAgentProgram()
      table =   Dict([PAC] => Action_Right,
                     [PAD] => Action_Suck,
                     [PBC] => Action_Left,
                     [PBD] => Action_Suck,
                     [PAC, PAC] => Action_Right,
                     [PAC, PAD] => Action_Suck,
                     [PAC, PAC, PAC] => Action_Right,
                     [PAC, PAC, PAD] => Action_Suck)
      return new(table, Vector{VacuumPercept}())
    end
end


#Default lookup in utils.jl will throw exception
function lookup(table::Dict{Vector{VacuumPercept}, Action},
                percepts::Vector{VacuumPercept})
    if (haskey(table, percepts))
        action = table[percepts]
        return action
    else
        return nothing
    end
end

"""
Technically the data in *Percept* is not very different from *State* as
the *SimpleReflexAgentProgram* contains no knowledge of overall model nor has
information of historical states.
"""
struct ReflexVacuumState <: State
    location_status::Tuple{Symbol, Symbol}
    ReflexVacuumState(location_status::Tuple{Symbol, Symbol})=new(location_status)
end

ReflexVacuumState(loc::AbstractString, cstate::AbstractString)=
    ReflexVacuumState((Symbol(loc), Symbol(cstate)))

const State_A_Clean=ReflexVacuumState("loc_A", "Clean")
const State_B_Clean=ReflexVacuumState("loc_B", "Clean")
const State_A_Dirty=ReflexVacuumState("loc_A", "Dirty")
const State_B_Dirty=ReflexVacuumState("loc_B", "Dirty")

"""
A method needed by the SimpleReflexAgentProgram abstraction to map

*Percept* to an internal *State* of the *AgentProgram*
"""
#=
In this case as the State datastructure is very similar to Persept mere
reinterpretatation carried out in reality there may be additional
transformations or data repurposing may be needed.
=#
function interpret_input(percept::VacuumPercept)
    return ReflexVacuumState(percept.location_status)
end

mutable struct MappingRule <: Rule
    state::State
    action::Action
end

const Rule_A_Clean = MappingRule(State_A_Clean,Action_Right)
const Rule_B_Clean = MappingRule(State_B_Clean,Action_Left)
const Rule_A_Dirty = MappingRule(State_A_Dirty,Action_Suck)
const Rule_B_Dirty = MappingRule(State_B_Dirty,Action_Suck)

mutable struct SimpleReflexVacuumAgentProgram <: SimpleReflexAgentProgram
    rules::Vector{Rule}
    SimpleReflexVacuumAgentProgram() = new([Rule_A_Clean, Rule_B_Clean,
                                            Rule_A_Dirty, Rule_B_Dirty])
end

function rule_match(state::State, rules::Vector{Rule})
    i = findfirst(x -> x.state == state, rules)
    return rules[i]
end

"""
*ReflexVacuumAgentProgram* is a simple *Percept* to *Action* matching model
only catering to the vacuum robot environment.

It does not depend on the historical percept data.

Fig 2.8 Pg. 48, AIMA 3ed
"""

struct ReflexVacuumAgentProgram <: AgentProgram end

function execute(ap::ReflexVacuumAgentProgram, percept::VacuumPercept)
    location = percept.location_status[1]
    status = percept.location_status[2]
    action = (status == Symbol("Dirty")) ? Action_Suck :
             (location == :loc_A) ? Action_Right :
             (location == :loc_B) ? Action_Left : nothing
    return action
end

"""
Model is a theoretical representation of the system or world. Sensors of the
Agent are the eyes and ears of the system to update the model.

The model has its internal states which will vary for *AgentProgram*.

In the *VacuumEnvironment* we choose the following as a Model.

**Model**

Model|Loc_A|Loc_B|
=====|=====|=====|
Agent|  1  |  0  |
=====|=====|=====|
Dirty|  1  |  1  |
=====|=====|=====|

Existence of the agent or dirt is shown as    : 1
Non-Existence of the agent or dirt is shown as: 0
When status is unknown it's kept as           :-1

Hence, when the model is initialized it will be a 2x2 grid as below:

Model|Loc_A|Loc_B|
=====|=====|=====|
Agent| -1  |  -1 |
=====|=====|=====|
Dirty| -1  |  -1 |
=====|=====|=====|

Hence, effectively there are 3 states per slot leading to 3^4=81 states.

However, as  you can see some states are impossible for example we know there is
only one agent. Hence, when location of the agent is known it's fairly
deterministic.

Agent state can be: (1,0) for loc_A or (0,1) for loc_B.
Indeterminate state (-1,-1) can be only for the first time but never
subsequently.

For example, the following states are impossible in the model.
First 2 elements are agent states and second 2 are the dirt state.

-1, 0, 0, 0   <-I1. Agent state in one location tells the other location state.
-1, 1, 0, 0   <-I2. Same as S1
-1,-1,-1, 0   <-I3. Dirt state known means agent state cannot be unknown.
-1,-1,-1, 1   <-I4. Same as S3.
-1,-1, 0, 0   <-I5. Same as S3
-1,-1, 0, 1   <-I6. Same as S3
-1,-1, 1, 0   <-I7. Same as S3
-1,-1, 1, 1   <-I8. Same as S3
...

Effectively, the model has only following valid environment states.

-1,-1,-1,-1   <-R0. Initial state Agent has not received any Percept.
                    Ignore this state and move read next Percept
 1, 0, 1,-1   <-R1. Agent goes to loc_A first. sees dirt.    -> Suck
 1, 0, 0,-1   <-R2. Agent goes to loc_A first. sees no dirt. -> Right
 0, 1,-1, 1   <-R3. Agent goes to loc_B first. sees dirt.    -> Suck
 0, 1,-1, 0   <-R4. Agent goes to loc_B first. sees no dirt. -> Left
 1, 0, 1, 0   <-R5. Agent goes to loc_A second.sees dirt.    -> Suck
 1, 0, 0, 0   <-R6. Agent goes to loc_A second.sees no dirt. -> NoOp
 0, 1, 0, 1   <-R7. Agent goes to loc_B second.sees dirt.    -> Suck
 0, 1, 0, 0   <-R8. Agent goes to loc_B second.sees no dirt. -> NoOp

 When Agent goes second time the first location has to be clean and cannot be
 unknown or dirty.

Due to the presence of the model the previous states are captured and
decisions can be taken on NoOp. One can also see an inherent assumption in the
model, dirt does not get generated in the locations autonomously nor added by
someone external. Those will fail the model.

Note: States here are very different from that of the
*SimpleReflexVacuumAgentProgram*
"""

struct ModelVacuumState <: State
    val::Tuple{Int,Int,Int,Int}
    ModelVacuumState(v::Tuple{Int,Int,Int,Int}) = new(v)
end

ModelVacuumState(v::Vector{Int}) = ModelVacuumState(tuple(v...))

const R1 = MappingRule(ModelVacuumState([1, 0, 1,-1]), Action_Suck)
const R2 = MappingRule(ModelVacuumState([1, 0, 0,-1]), Action_Right)
const R3 = MappingRule(ModelVacuumState([0, 1,-1, 1]), Action_Suck)
const R4 = MappingRule(ModelVacuumState([0, 1,-1, 0]), Action_Left)
const R5 = MappingRule(ModelVacuumState([1, 0, 1, 0]), Action_Suck)
const R6 = MappingRule(ModelVacuumState([1, 0, 0, 0]), Action_NoOp)
const R7 = MappingRule(ModelVacuumState([0, 1, 0, 1]), Action_Suck)
const R8 = MappingRule(ModelVacuumState([0, 1, 0, 0]), Action_NoOp)

mutable struct ModelBasedVacuumAgentProgram <: ModelBasedReflexAgentProgram
    model::Vector{Int}
    rules::Vector{Rule}
    state::ModelVacuumState
    action::Action

    function ModelBasedVacuumAgentProgram()
        model = [-1,-1,-1,-1]
        rules = [R1, R2, R3, R4, R5, R6, R7, R8]
        state = ModelVacuumState([-1,-1,-1,-1])
        action = Action_NoOp
        return new(model, rules, state, action)
    end
end

function update_state(state::ModelVacuumState, action::Action,
    percept::VacuumPercept, model::Vector{Int})

    #Update model with previous state
    for i=1:4
        model[i] = state.val[i]
    end

    loc = percept.location_status[1]
    status = percept.location_status[2]

    #Apply the previous action on the model as well
    #If previous action does not match reset the model to initialized
    if (action == Action_Right)
        if (loc == :loc_A)
            copy!(model,[-1,-1,-1,-1])
        end
    elseif (action == Action_Left)
        if (loc == :loc_B)
            copy!(model,[-1,-1,-1,-1])
        end
    elseif (action == Action_Suck)
        if (model[1]==1)
            model[3] = 0
        elseif (model[2]==1)
            model[4] = 0
        end
    end

    if (loc == Symbol("loc_A"))
        model[1] = 1; model[2] = 0
        model[3] = (status == Symbol("Dirty")) ? 1 : 0
    else
        model[1] = 0; model[2] = 1
        model[4] = (status == Symbol("Dirty")) ? 1 : 0
    end

    println(model)

    return ModelVacuumState(model)
end

function RunVacuumAgent(AP::Type)
    percept_sequence = [PAC PAD PBD]
    println("Run the $(string(AP))")
    agent=Agent{AP}(AP())
    actions=[]
    for percept in percept_sequence
        action = execute(agent, percept)
        push!(actions, action)
    end
    return actions
end

const RunTableDrivenVacuumAgentResult=[Action_Right, Action_Suck, nothing]
RunTableDrivenVacuumAgent()=RunVacuumAgent(TableDrivenVacuumAgentProgram)
const RunSimpleReflexVacuumAgentResult=[Action_Right, Action_Suck, Action_Suck]
RunSimpleReflexVacuumAgent()=RunVacuumAgent(SimpleReflexVacuumAgentProgram)
const RunReflexVacuumAgentResult=[Action_Right, Action_Suck, Action_Suck]
RunReflexVacuumAgent()=RunVacuumAgent(ReflexVacuumAgentProgram)
RunModelBasedVacuumAgentResult=[Action_Right, Action_Suck, Action_Suck]
RunModelBasedVacuumAgent()=RunVacuumAgent(ModelBasedVacuumAgentProgram)

end

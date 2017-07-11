using Compat

#=
Methods needed in a sequence. Sequence shall not mean an Array or Vector.
The domain can decide the sequence based on the need. It shall have following
Methods
=#

#isempty(seq)=error(E_ABSTRACT)
first(seq)=error(E_ABSTRACT)
rest(seq)=error(E_ABSTRACT)
append(seq,data)=error(E_ABSTRACT)

#=
Methods needed in a queue. Queue shall not mean an Array or Vector.
The domain can decide the sequence based on the need. It shall have following
Methods
=#

#@compat abstract type Queue end

#@compat abstract type PriorityQueue end


#isempty(queue)=error(E_ABSTRACT)
empty(queue)=error(E_ABSTRACT)
pop(queue)=error(E_ABSTRACT)
insert(queue,data)=error(E_ABSTRACT)

#=
Specializations for Vectors

isempty, first are available for AbstractArray
=#
rest(seq::Vector)=(shift!(seq);seq)
append(seq::Vector,data)=(push!(seq,data))
insert(queue::Vector,data)=append(queue, data)
pop(queue::Vector)=shift!(queue)
empty(queue::Vector)=empty!(queue)

append(set::Set,data)=(push!(set,data))



#=function in{T<:State}(state::T, )

Methods needed in a table. Table shall not mean an Array or Dict.
The domain can decide the table based on the need. It shall have following
Methods.
=#
lookup(table,key)=error(E_ABSTRACT)

#=
Specializations for Dict

This will throw an exception if key is not found.
=#
lookup(table::Dict,key)=(table[key])

# This file is a part of project JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/NodeNumbering.jl/blob/master/LICENSE

"""
    create_adjacency_graph(elements::Dict{Int, Vector{Int}}, element_types::Dict{Int, Symbol})

Create a Dict that shows all nodes and their adjacencies.

# Constants

The element dict, the element_types dict and the element_adjacencies dict.

# Examples

```jldoctest
julia> elements = Dict(
                  1 => [9, 1, 8, 4],
                  2 => [1, 3, 2, 8],
                  3 => [8, 2, 7, 5],
                  4 => [2, 6, 7]);

julia> element_types = Dict(
                       1 => :Quad4,
                       2 => :Quad4,
                       3 => :Quad4,
                       4 => :Tri3);

julia> element_adjacencies = Dict(
                             :Quad4 => [[2, 4], [1, 3], [2, 4], [1, 3]],
                             :Tri3 => [[2,3], [1,3], [1,2]],
                             :Tet4 => [[2,3,4], [1,3,4], [1,2,4], [1,2,3]]);

julia> create_adjacency_graph(elements, element_types, element_adjacencies)
Dict(
1 => [3, 8, 9],
2 => [3, 8, 7],
3 => [1, 2],
4 => [8, 9],
5 => [7, 8],
6 => [2, 7],
7 => [5, 2, 6],
8 => [1, 2, 4, 5],
9 => [1, 4]);
```

# References

* Wikipedia contributors. "Adjacency list". Wikipedia, The Free Encyclopedia. Wikipedia, The Free Encyclopedia, 7 Jun. 2017. Web. 17 Jul. 2017. https://en.wikipedia.org/wiki/Adjacency_list
"""
function create_adjacency_graph(elements::Dict{Int, Vector}, element_types::Dict{Int, Symbol}, element_adjacencies::Dict{Symbol, Vector{Vector{Int}}})
    neighbours = Dict{Int, Vector{Int}}()
    for (k, nodes) in elements
        neighbour_indices = element_adjacencies[element_types[k]]
        for (i, node) in enumerate(nodes)
            node_neighbours = nodes[neighbour_indices[i]]
            if haskey(neighbours, node)
                 for nodei in node_neighbours
                    if (nodei in neighbours[node]) == false
                       push!(neighbours[node], nodei)
                    end
                end
            else
                neighbours[node] = node_neighbours
            end
        end
    end
    return neighbours
end

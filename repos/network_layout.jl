using GraphPlot
using Graphs
# a=Graph(nBus)
#
# for i in 1:nLines
#     add_edge!(a, nw_lines[i].line_from, nw_lines[i].line_to)
#
# end
# for i in 1:size(nw_trans,1)
#     add_edge!(a, nw_trans[i].trans_bus_from, nw_trans[i].trans_bus_to)
# end
# nodelabel = 1:nv(a)
# # gplot(a,nodelabelsize=0.1,  nodelabel=nodelabel)
#
# layout=(args...)->spring_layout(args...; C=2)
#
# nodelabelsize = [Graphs.outdegree(a, v) for v in Graphs.vertices(a)]
#
# gplot(a, layout=layout,nodelabelsize=nodelabelsize, nodelabel=nodelabel)


# draw(PDF("network_topology.pdf", 20cm, 20cm), gplot(a, layout=layout,nodelabelsize=nodelabelsize, nodelabel=nodelabel))

# node_data_updated

# counter=[]
# for n in 1:nBus
#
#     if node_data_updated[n]!=[]
#         # i=1
#         push!(counter,1)
#     end
# end
# length(counter)
node_data_updated=deepcopy(node_data_new)
a=Graph(nBus)
# a=Graph(50)
check=[]
for n in 1:nBus
    if node_data_updated[n]!=[]
        for j in 1:size(node_data_updated[n].node_num,1)
    add_edge!(a, node_data_updated[n].node_num[j], node_data_updated[n].node_cnode[j])
# push!(check, [node_data_updated[n].node_num[j][1], node_data_updated[n].node_cnode[j][1]])
end
else
push!(check, n)
#    rem_vertex!(a, n)
end
end
# check=unique!(check)
# for i in check[101:110]
# rem_vertex!(a, i)
# end

# for i in 1:size(nw_trans,1)
#     add_edge!(a, nw_trans[i].trans_bus_from, nw_trans[i].trans_bus_to)
# end
# nodelabel = 1:nBus
nodelabel = 1:nv(a)
# gplot(a,nodelabelsize=0.1,  nodelabel=nodelabel)

layout=(args...)->spring_layout(args...; C=3)

nodelabelsize = [Graphs.outdegree(a, v) for v in Graphs.vertices(a)]


gplot(a, layout=layout,nodelabelsize=15, nodelabel=nodelabel, nodelabelc="black")

# using Cairo, Compose
# draw(PDF("output_data\\network_topology_new1.pdf", 10cm, 10cm), gplot(a, layout=layout,nodelabelsize=15, nodelabel=nodelabel, nodelabelc="blue"))

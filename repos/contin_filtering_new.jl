
node_data_updated=deepcopy(node_data_new)
# isolated_nodes=[]
# while ~isempty((1 for n=1:nBus if size(node_data_updated[n].node_num,1)==1) if node_data_updated[n]!=[] )
iter= 1
# while ~isempty(findall(x->x==1, [size(node_data_updated[n].node_num,1)==1 for n in 1:nBus if node_data_updated[n]!=[]]))
while iter<=5
    # local iter=0
# for n in 1:nBus
for n in 1:nBus
    if node_data_updated[n]!=[]
    if size(node_data_updated[n].node_num,1)==1
       if node_data_updated[node_data_updated[n].node_cnode[1]]!=[]
        deleteat!(node_data_updated[node_data_updated[n].node_cnode[1]].node_num, 1)
        deleteat!(node_data_updated[node_data_updated[n].node_cnode[1]].node_cnode,findall(x->x==n, node_data_updated[node_data_updated[n].node_cnode[1]].node_cnode)[1])

    end
     node_data_updated[n]=[]
end
end
end
global iter += 1
end


islanded_lines=[]
# =findall(x->x==1, [size(node_data_updated[n].node_num,1)==1 for n in 1:nBus if node_data_updated[n]!=[]])
for i in 1:nBus
    if node_data_updated[i]!=[]
    if size(node_data_updated[i].node_num,1)==1
push!(islanded_lines, i)
end
end
end

# remove transformers
for n in 1:nBus
    if node_data_updated[n]!=[]
      if node_data_trans[n]!=[]
          idx_trans=findall(x->x in node_data_trans[n].node_cnode, node_data_updated[n].node_cnode  )
          deleteat!(node_data_updated[n].node_num, idx_trans)
          deleteat!(node_data_updated[n].node_cnode,idx_trans)
          if node_data_updated[n].node_num==[]
              node_data_updated[n]=[]
          end
# push!(include_lines, [n,node_data_updated[n].node_cnode[1] ])
#       else
# push!(include_lines, [n,node_data_updated[n].node_cnode[1] ])
end
end
end

include_lines=[]
for n  in 1:nBus
    if node_data_updated[n]!=[]
        for j in 1:size(node_data_updated[n].node_cnode,1)
push!(include_lines, [n,node_data_updated[n].node_cnode[j] ])
end
end
end

include_lines=unique!(include_lines)



idx_line_contin=convert(Array{Int64,2},idx_line)
in_line_set=[]
for i in 1:length(include_lines)
    from_1=findall(x->x==include_lines[i][1],idx_line_contin[:,1])
    to_1  =findall(x->x==include_lines[i][2],idx_line_contin[:,2])
    from_2=findall(x->x==include_lines[i][2],idx_line_contin[:,1])
    to_2  =findall(x->x==include_lines[i][1],idx_line_contin[:,2])

    in_line_1=intersect(from_1, to_1)
    in_line_2=intersect(from_2, to_2)
    if ~isempty(in_line_1)
    push!(in_line_set, in_line_1)
end
    if ~isempty(in_line_2)
    push!(in_line_set, in_line_2)
end
end



in_line_set=unique!(in_line_set)

line_from_to_idx=[idx_line[i[1],:] for i in in_line_set]

include_lines_from=[line_from_to_idx[i][1] for i in 1:size(line_from_to_idx,1)]
include_lines_to=[line_from_to_idx[i][2] for i in 1:size(line_from_to_idx,1)]
include_new= [1:size(line_from_to_idx,1) include_lines_from include_lines_to ]

ods_write("input_data\\$(nam)_PROF.ods",Dict(("contingencies",2,1)=>include_new))
# C:\\Users\\alizadeh\\Desktop\\LIST\\00_Code_tract\\Tract_R57\\input_data

# now remove the transformers

# isolated_nodes=sort!(isolated_nodes)
#
# node_data_updated1=deleteat!(node_data_updated,isolated_nodes)

# iteration=~isempty(size(node_data_updated[i].node_num,1)==1) for i in 1:nBus if ~isempty(node_data_updated[i].node_num)
#
# # node_data_new=node_data
# for n in 1:nBus
#     if !isempty(node_data[n].node_num)
#   #       if        size(node_data[n].node_num,1)==1
#   #       # for i in 1:length(node_data[n].node_num)
#   #
#   #    if node_data[n].node_parallel[1]!=1
#   #         push!(include_lines, [n,node_data[n].node_cnode[1] ])
#   #     # end
#   # end
# if size(node_data[n].node_num,1)==1 && isempty(node_data_trans[n].node_num)
#       if node_data[n].node_parallel[1]==1
#   # for i in 1:length(node_data[n].node_num)
#            push!(exclude_lines, [n,node_data[n].node_cnode[1] ])
#        end
#             # for i = 1:nCont                                                                # nLines = nTrsf + nTransmission lines
#                 # push!(idx_from_line_c, array_contin_lines[i].from_contin)                                # Saving 'from' end of lines in a vector
#                 # push!(idx_to_line_c, array_contin_lines[i].to_contin)                                    # Saving 'to' end of lines in a vector
#             end
#             # push!(include_lines, [n,node_data[n].node_cnode[1] ])
#         end
#     end
#
# exclude_lines=unique!(exclude_lines)
# #     include_lines_from=[include_lines[i][1] for i in 1:size(include_lines,1)]
# #     include_lines_to=[include_lines[i][2] for i in 1:size(include_lines,1)]
# # for i in 1:length(include_lines)
# #     from_idx=findall(x->x==)
#
# idx_line_contin=convert(Array{Int64,2},idx_line)
# ex_line_set=[]
# for i in 1:length(exclude_lines)
#     from_1=findall(x->x==exclude_lines[i][1],idx_line_contin[:,1])
#     to_1  =findall(x->x==exclude_lines[i][2],idx_line_contin[:,2])
#     from_2=findall(x->x==exclude_lines[i][2],idx_line_contin[:,1])
#     to_2  =findall(x->x==exclude_lines[i][1],idx_line_contin[:,2])
#
#     ex_line_1=intersect(from_1, to_1)
#     ex_line_2=intersect(from_2, to_2)
#     if ~isempty(ex_line_1)
#     push!(ex_line_set, ex_line_1)
# end
#     if ~isempty(ex_line_2)
#     push!(ex_line_set, ex_line_2)
# end
# end
#
# ex_line_set=unique!(ex_line_set)

# include_line_final=[]
# for i in 1:nLines
#     if isempty(findall(x->x==[i], ex_line_set))
#     push!(include_line_final, idx_line[i,:] )
# end
# end

# new_include_lines=unique!(include_lines)
#     for i in 1:length(include_lines)
#         aux1=findall(x->x==[include_lines[i][1],include_lines[i][2]],include_lines )
#         if size(aux1,1)>1
#         deleteat!(include_lines,[aux1[1]])
#     end end
#
#
# include_convert=convert(Int64, length(include_lines)/2)
# for i in 1:include_convert
#     aux1=findall(x->x==[include_lines[i][2],include_lines[i][1]],include_lines )
#     if ~isempty(aux1)
#     deleteat!(include_lines,[aux1[1]])
# end end
# new_include_lines=unique!(include_lines)

# include_lines_from=[include_line_final[i][1] for i in 1:size(include_line_final,1)]
# include_lines_to=[include_line_final[i][2] for i in 1:size(include_line_final,1)]
# include_new= [1:size(include_line_final,1) include_lines_from include_lines_to ]

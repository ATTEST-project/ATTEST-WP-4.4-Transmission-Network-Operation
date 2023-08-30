using CSV, DataFrames
# pinj_dict
# qinj_dict
# pinj_dict_l
# qinj_dict_l
# pinj_dict_c
# qinj_dict_c
# pinj_dict_l_c
# qinj_dict_l_c


#-----------------------------severity CSV  file generation---------------------
# line_flow_normal=Dict{NTuple{3,Int64},Float64}()
# for  t in 1:nTP, l in 1:nLines
#     push!(line_flow_normal,  (t,idx_from_line[l],idx_to_line[l])=>
# sqrt(value.(pinj_dict[[t,idx_from_line[l],idx_to_line[l]]])^2+value.(qinj_dict[[t,idx_from_line[l],idx_to_line[l]]])^2)/nw_lines[l].line_Smax_A
#      )
#      for tr in 1:nTrans
#          push!(line_flow_normal,  (t,nw_trans[tr].trans_bus_from,nw_trans[tr].trans_bus_to)=>
#      sqrt(value.(pinj_dict[[t,nw_trans[tr].trans_bus_from,nw_trans[tr].trans_bus_to]])^2+value.(qinj_dict[[t,nw_trans[tr].trans_bus_from,nw_trans[tr].trans_bus_to]])^2)/nw_trans[tr].trans_Snom
#           )
#  end
# end
idx_line=Array{Int64,2}(idx_line)
if nTrans!=0
    idx_trans=Array{Int64,2}(rdata_transformers[:,1:2])
    idx_l_t=vcat(idx_line, idx_trans)
 else
     idx_l_t=idx_line
     idx_pl_l_t=idx_plines
 end

idx_pl_l_t=vcat(idx_plines,idx_ptranses)

if nCont!=0




   line_flow_contin=Dict{NTuple{6,Int64},Float64}()

nsub_cont=[]
if nCont>=5
    nsub_cont=5
else
    nsub_cont=1
end

for c in 1:nsub_cont
         ASSET_line=intersect(findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][1], idx_l_t[:,1] ), findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][2], idx_l_t[:,2] ) )
    for  s in 1, t in [12,20],  l in 1:length(idx_l_t[:,1])
         # ASSET_trans=intersect(findall3(x->x==nw_trans[trn].trans_bus_from, idx_l_t[:,1] ), findall3(x->x==nw_trans[trn].trans_bus_to, idx_l_t[:,2] ) )
   if haskey(pinj_dict_c, [c,s,t,idx_l_t[l,1],idx_l_t[l,2]])
       apparent_pwr=sum(sqrt(value.(pinj_dict_c[[c,s,t,idx_l_t[l,1],idx_l_t[l,2]]])^2+value.(qinj_dict_c[[c,s,t,idx_l_t[l,1],idx_l_t[l,2]]])^2 ) for s in 1, t in 1:2)
       if l<=length(idx_line[:,1])
            if isnothing(indexin(c, idx_pll_aux)[1])
              push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
                 apparent_pwr/(nw_lines[l].line_Smax_A*2) )
           elseif !isnothing(indexin(c, idx_pll_aux)[1])
                if l==ASSET_line[1]
                    push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
                       apparent_pwr/(nw_lines[l].line_Smax_A*((size(idx_plines[l],1)-1)/(size(idx_plines[l],1)))*2) )
             elseif l!=ASSET_line[1]
                    push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
                    apparent_pwr/(nw_lines[l].line_Smax_A*2) )
              end
          end
     elseif l>length(idx_line[:,1])
          push!(line_flow_contin, (ASSET_line[1],idx_line[list_of_contingency_lines[c][1],:][1],idx_line[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
             apparent_pwr/(nw_trans[l-length(idx_line[:,1])].trans_Snom*2) )
      end
  elseif !haskey(pinj_dict_c, [c,s,t,idx_l_t[l,1],idx_l_t[l,2]])
    push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>0)
   end
end
end



# apparent_val=Dict{NTuple{5,Int64},Float64}()
# @elapsed(
# for (c,s,t,fr,to) in eachindex(pinj_dict_c)
#     push!(apparent_val, (c,s,t,fr,to)=>sum(sqrt(value.(pinj_dict_c[[c,s,t,fr,to]])^2+value.(qinj_dict_c[[c,s,t,fr,to]])^2 ) for s in 1:nSc, t in 1:nTP))
# end
# )
# @time(
# for c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_l_t[:,1])
#          ASSET_line=intersect(findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][1], idx_l_t[:,1] ), findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][2], idx_l_t[:,2] ) )
#          # ASSET_trans=intersect(findall3(x->x==nw_trans[trn].trans_bus_from, idx_l_t[:,1] ), findall3(x->x==nw_trans[trn].trans_bus_to, idx_l_t[:,2] ) )
#    if haskey(pinj_dict_c, [c,s,t,idx_l_t[l,1],idx_l_t[l,2]])
#        if l<=length(idx_line[:,1])
#             if isempty(findall3(x->x==c, idx_pll_aux))
#               push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
#                  values(apparent_val[c,s,t,idx_l_t[l,1],idx_l_t[l,2]]) /(nw_lines[l].line_Smax_A*nTP*nSc) )
#            elseif !isempty(findall3(x->x==c, idx_pll_aux))
#                 if l==ASSET_line[1]
#                     push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
#                        values(apparent_val[c,s,t,idx_l_t[l,1],idx_l_t[l,2]])/(nw_lines[l].line_Smax_A*((size(idx_plines[l],1)-1)/(size(idx_plines[l],1)))*nTP*nSc) )
#              elseif l!=ASSET_line[1]
#                     push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
#                     values(apparent_val[c,s,t,idx_l_t[l,1],idx_l_t[l,2]])/(nw_lines[l].line_Smax_A*nTP*nSc) )
#               end
#           end
#      elseif l>length(idx_line[:,1])
#           push!(line_flow_contin, (ASSET_line[1],idx_line[list_of_contingency_lines[c][1],:][1],idx_line[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>
#              values(apparent_val[c,s,t,idx_l_t[l,1],idx_l_t[l,2]])/(nw_trans[l-length(idx_line[:,1])].trans_Snom*nTP*nSc) )
#       end
#   elseif !haskey(pinj_dict_c, [c,s,t,idx_l_t[l,1],idx_l_t[l,2]])
#     push!(line_flow_contin, (ASSET_line[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],l,idx_l_t[l,1],idx_l_t[l,2]) =>0)
#    end
# end
# )

# @elapsed(
# for (c,fr,to) in eachindex(apparent_val)
#     ASSET_contin=intersect(findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][1], idx_l_t[:,1] ), findall3(x->x==idx_l_t[list_of_contingency_lines[c][1],:][2], idx_l_t[:,2] ) )
#     ASSET_branch=intersect(findall3(x->x==fr[1], idx_l_t[:,1] ), findall3(x->x==to[1], idx_l_t[:,2] ) )
#     if isempty(ASSET_branch)
#         ASSET_branch=intersect(findall3(x->x==fr[1], idx_l_t[:,2] ), findall3(x->x==to[1], idx_l_t[:,1] ) )
#     end
# ASSET_branch=ASSET_branch[1]
#     if ASSET_branch<=length(idx_line[:,1])
#          if isempty(findall3(x->x==c, idx_pll_aux))
#            push!(line_flow_contin, (ASSET_contin[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],ASSET_branch,fr,to) =>
#               values(apparent_val[c,fr,to])/(nw_lines[ASSET_branch].line_Smax_A*nTP*nSc) )
#         elseif !isempty(findall3(x->x==c, idx_pll_aux))
#              if ASSET_branch==ASSET_contin[1]
#                  push!(line_flow_contin, (ASSET_contin[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],ASSET_branch,fr,to) =>
#                     values(apparent_val[c,fr,to])/(nw_lines[ASSET_branch].line_Smax_A*((size(idx_plines[ASSET_branch],1)-1)/(size(idx_plines[ASSET_branch],1)))*nTP*nSc) )
#           elseif ASSET_branch!=ASSET_contin[1]
#                  push!(line_flow_contin, (ASSET_contin[1],idx_l_t[list_of_contingency_lines[c][1],:][1],idx_l_t[list_of_contingency_lines[c][1],:][2],ASSET_branch,fr,to) =>
#                  values(apparent_val[c,fr,to])/(nw_lines[ASSET_branch].line_Smax_A*nTP*nSc)  )
#            end
#        end
#   elseif ASSET_branch>length(idx_line[:,1])
#        push!(line_flow_contin, (ASSET_contin[1],idx_line[list_of_contingency_lines[c][1],:][1],idx_line[list_of_contingency_lines[c][1],:][2],ASSET_branch,fr,to) =>
#            values(apparent_val[c,fr,to])/(nw_trans[ASSET_branch-length(idx_line[:,1])].trans_Snom*nTP*nSc) )
#    end
#    push!(line_flow_contin, (ASSET_contin[1],idx_line[list_of_contingency_lines[c][1],:][1],idx_line[list_of_contingency_lines[c][1],:][2],ASSET_contin[1],idx_line[list_of_contingency_lines[c][1],:][1],idx_line[list_of_contingency_lines[c][1],:][2]) =>
#           0)
#
# end
# )





parallel_line_trans_indicator=Dict{NTuple{6,Int64},Int64}()
number_of_prll=Dict{NTuple{6,Int64},Int64}()
for (i1,i2,i3,i4,i5,i6) in eachindex(line_flow_contin)
    for j in 1:length(idx_l_t[:,1])
    if i5==idx_l_t[j,1] && i6==idx_l_t[j,2]
        if size(idx_pl_l_t[j],1)>1
      push!(parallel_line_trans_indicator, (i1,i2,i3,i4,i5,i6)=>1)
      push!(number_of_prll, (i1,i2,i3,i4,i5,i6)=>size(idx_pl_l_t[j],1))
       else
    push!(parallel_line_trans_indicator, (i1,i2,i3,i4,i5,i6)=>0)
    push!(number_of_prll, (i1,i2,i3,i4,i5,i6)=>0 )
end
end
end
end

# intersect(findall3(x->x==idx_line[list_of_contingency_lines[1][1],:][1], idx_line[:,1] ), findall3(x->x==idx_line[list_of_contingency_lines[1][1],:][2], idx_line[:,2] ) )

# keys_line_flow=collect(keys(line_flow_contin))
values_line_flow=collect(values(line_flow_contin))
values_parallel=collect(values(parallel_line_trans_indicator))
values_numb_prll_lt=collect(values(number_of_prll))
# linef=zeros(length(line_flow_contin),5)
# for  i in eachindex(line_flow_contin)
#     linef[i]=[keys(line_flow_contin[i])]
# end
# linef=[keys_line_flow[i][1], keys_line_flow[i][2] for i in 1:length(line_flow_contin)]


df1=DataFrame( keys(line_flow_contin),  )
df2=DataFrame( :severity=>values_line_flow)
df4=DataFrame( :parallel=>values_parallel)
df5=DataFrame( :Number_prll=>values_numb_prll_lt)
df3=[df1 df2 df4 df5]

new_df2=Array{Int64,1}(zeros(length(df3[!,1])))
new_df3=Array{Int64,1}(zeros(length(df3[!,1])))
new_df5=Array{Int64,1}(zeros(length(df3[!,1])))
new_df6=Array{Int64,1}(zeros(length(df3[!,1])))
for i in 1:length(df3[!,1])
    new_df2[i]=bus_m[df3[!,2][i]]
    new_df3[i]=bus_m[df3[!,3][i]]
    new_df5[i]=bus_m[df3[!,5][i]]
    new_df6[i]=bus_m[df3[!,6][i]]
end

df3[!,2]=new_df2
df3[!,3]=new_df3
df3[!,5]=new_df5
df3[!,6]=new_df6


# df3=[df1 df2 ]
df_severity=sort!(df3)
rename!(df_severity,:1 => :Failed_Asset_ID
         , :2 => :Failed_fbus
         , :3 => :Failed_tbus
         # , :4 => :Scenarios
         # , :5 => :time
         , :4 => :ASSET_ID
         , :5 => :fbus
         , :6 => :tbus
         )

# df = DataFrame(Contingencies=1:3, Conitn_from=5:7, Contin_to=1)
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_severity_transmission.csv", df_severity)



else
    println("")
    show("The severity output is skipped since there is no contingency.")
    println("")

end

#----------------prof p CSV file generation-------


active_flow_normal=Dict{NTuple{3,Int64},Float64}()
# for  t in 1:nTP, l in 1:nLines
#     push!(active_flow_normal,  (t,idx_from_line[l],idx_to_line[l])=>
#   abs.(value.(pinj_dict[[t,idx_from_line[l],idx_to_line[l]]]))
#      )
#      for tr in 1:nTrans
#          push!(active_flow_normal,  (t,nw_trans[tr].trans_bus_from,nw_trans[tr].trans_bus_to)=>
#      abs.(value.(pinj_dict[[t,nw_trans[tr].trans_bus_from,nw_trans[tr].trans_bus_to]]))
#           )
#  end
# end
for  t in 1:nTP, l in 1:length(idx_l_t[:,1])
  #   push!(active_flow_normal,  (t,idx_from_line[l],idx_to_line[l])=>
  # abs.(value.(pinj_dict[[t,idx_from_line[l],idx_to_line[l]]]))
  #    )
  #    for tr in 1:nTrans
         push!(active_flow_normal,  (t,idx_l_t[l,1],idx_l_t[l,2])=>
     abs.(value.(pinj_dict[[t,idx_l_t[l,1],idx_l_t[l,2]]]))
          )
 # end
end
# values_active_flow_normal=collect(values(active_flow_normal))
# df_active1=DataFrame(keys(active_flow_normal))

# each_time_flow=Dict(Dict())
# for (t,fr,to) in eachindex(active_flow_normal), time in 1:nTP
#     if time==t
#         push!(each_time_flow, t=> values(active_flow_normal[t,fr,to]))
#     end
# end

each_time_flow=zeros(length(idx_l_t[:,1]),nTP)
for t in 1:nTP, l in 1:length(idx_l_t[:,1])
    each_time_flow[l,t]=values(active_flow_normal[t,idx_l_t[l,1],idx_l_t[l,2]])
end







# PG=round.(value.(Pg), digits=2)
# PG=transpose(PG)
df_active_flow_normal=DataFrame(each_time_flow, :auto)
# df_active3=[df_active1 df_active2]
# df_active_flow_normal=sort!(df_active3)
if nTP==1

rename!(df_active_flow_normal,
 :x1 => :h1
      )
  elseif nTP==24
rename!(df_active_flow_normal,
 :x1 => :h1,  :x2 => :h2,  :x3 => :h3, :x4 => :h4, :x5 => :h5, :x6 => :h6, :x7 => :h7, :x8 => :h8
, :x9 => :h9,  :x10 => :h10,  :x11 => :h11, :x12 => :h12, :x13 => :h13, :x14 => :h14, :x15 => :h15, :x16 => :h16
, :x17 => :h17, :x18 => :h18, :x19 => :h19, :x20 => :h20, :x21 => :h21, :x22 => :h22, :x23 => :h23, :x24 => :h24

      )
end
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_prof_p.csv", df_active_flow_normal)



#----------------prof Q CSV file generation-------


reactive_flow_normal=Dict{NTuple{3,Int64},Float64}()
for  t in 1:nTP, l in 1:length(idx_l_t[:,1])

         push!(reactive_flow_normal,  (t,idx_l_t[l,1],idx_l_t[l,2])=>
     abs.(value.(qinj_dict[[t,idx_l_t[l,1],idx_l_t[l,2]]]))
          )

end





each_time_flow_re=zeros(length(idx_l_t[:,1]),nTP)
for t in 1:nTP, l in 1:length(idx_l_t[:,1])
    each_time_flow_re[l,t]=values(reactive_flow_normal[t,idx_l_t[l,1],idx_l_t[l,2]])
end
df_reactive_flow_normal=DataFrame(each_time_flow_re, :auto)

if nTP==1

rename!(df_reactive_flow_normal,
 :x1 => :h1
      )
  elseif nTP==24
rename!(df_reactive_flow_normal,
 :x1 => :h1,  :x2 => :h2,  :x3 => :h3, :x4 => :h4, :x5 => :h5, :x6 => :h6, :x7 => :h7, :x8 => :h8
, :x9 => :h9,  :x10 => :h10,  :x11 => :h11, :x12 => :h12, :x13 => :h13, :x14 => :h14, :x15 => :h15, :x16 => :h16
, :x17 => :h17, :x18 => :h18, :x19 => :h19, :x20 => :h20, :x21 => :h21, :x22 => :h22, :x23 => :h23, :x24 => :h24

      )
end
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_prof_q.csv", df_reactive_flow_normal)





#--------------------------------mpc_asset_prof CSV file generation------------------------------


mpc_asset_prof=Dict{NTuple{3,Int64},Int64}()
# idx_line=Array{Int64,2}(idx_line)
for   l in 1:length(idx_l_t[:,1])
    # ASSET=intersect(findall3(x->x==idx_line[list_of_contingency_lines[c][1],:][1], idx_line[:,1] ), findall3(x->x==idx_line[list_of_contingency_lines[c][1],:][2], idx_line[:,2] ) )

    push!(mpc_asset_prof, (l,idx_l_t[l,1],idx_l_t[l,2]) =>l
)
end

df1=DataFrame( keys(mpc_asset_prof),  )
df2=DataFrame( :severity=>collect(values(mpc_asset_prof)))
df3=[df1 df2]

# df3=[df1 df2 df4 df5]

new_df2=Array{Int64,1}(zeros(length(df3[!,1])))
new_df3=Array{Int64,1}(zeros(length(df3[!,1])))
# new_df5=Array{Int64,1}(zeros(length(df3[!,1])))
# new_df6=Array{Int64,1}(zeros(length(df3[!,1])))
for i in 1:length(df3[!,1])
    new_df2[i]=bus_m[df3[!,2][i]]
    new_df3[i]=bus_m[df3[!,3][i]]
    # new_df5[i]=bus_m[df3[!,5][i]]
    # new_df6[i]=bus_m[df3[!,6][i]]
end

df3[!,2]=new_df2
df3[!,3]=new_df3
# df3[!,5]=new_df5
# df3[!,6]=new_df6





df_mpc_asset_prof=sort!(df3)
rename!(df_mpc_asset_prof
         # ,:1 => :Failed_Asset_ID
         # , :2 => :Failed_fbus
         # , :3 => :Failed_tbus
         # , :4 => :Scenarios
         # , :5 => :time
         , :1 => :ASSET_ID
         , :2 => :fbus
         , :3 => :tbus
         , :4 => :Profile_ID
         )

# df = DataFrame(Contingencies=1:3, Conitn_from=5:7, Contin_to=1)
# CSV.write("output_data\\output_to_WP5\\$(nam)_Severity.csv", df)
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_asset_prof.csv", df_mpc_asset_prof)

#---------------time interval CSV file generation----------
time_interval=convert(Array{Int64,2}, ones(length(idx_l_t[:,1]),1) )[:,1]
df_time=DataFrame( [time_interval], [:Time_interval])
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_prof_fraction.csv", df_time)

#-------------profile id CSV file generation------------
profile_id=1:1:length(idx_l_t[:,1])
profile_id=hcat(profile_id)[:,1]
df_id=DataFrame( [profile_id], [:Profile_ID])
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_prof_id.csv", df_id)
#-------------prof mode  CSV file generation------------
profile_mode=convert(Array{Int64,2}, 3*ones(length(idx_l_t[:,1]),1) )[:,1]
profile_mode=hcat(profile_mode)[:,1]
df_mode=DataFrame( [profile_mode], [:Mode])
CSV.write("output_data\\output_to_WP5\\$(nam)_$(yr)_$(sw)_$(wf)_mpc_prof_mode.csv", df_mode)

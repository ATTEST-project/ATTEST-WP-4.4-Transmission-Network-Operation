function variables_t_n(model_name)

@variable(model_name, v_sq[ j = 1:nTP, k = 1:nBus], start=1.0)#,(start = 1.00)                                  # This procedure can be used to set the start values of all variables

@variable(model_name, teta[ t= 1:nTP, i=1:nBus], start=0.0)
# @variable(model_name, slack_p[s=1:nSc, t= 1:nTP, i=1:nBus, l=1:nBus], lower_bound=0)
# @variable(model_name, slack_n[s=1:nSc, t= 1:nTP, i=1:nBus, l=1:nBus], lower_bound=0)
# @variable(model_name, slack_v_p[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_v_n[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_pb_p[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_pb_n[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_rb_p[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_rb_n[s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)

@variable(model_name, pen_ws[  j = 1:nTP, k = 1:nRES], start=0.5*prof_PRES[1,j,k],lower_bound=0.0, upper_bound=prof_PRES[1,j,k])
@variable(model_name, pen_lsh[ j = 1:nTP, k = 1:nLoads], start=0.5*prof_ploads[k,j],lower_bound=0.0, upper_bound=abs.(prof_ploads[k,j]))
@variable(model_name, Pg[ j = 1:nTP, k = 1:nGens]  )
@variable(model_name, Qg[ j = 1:nTP, k = 1:nGens])
p_fl_inc=nothing
p_fl_dec=nothing
  # if nFl!=0
      @variable(model_name, p_fl_inc[ j = 1:nTP, k = 1:nFl], start=0,lower_bound=0.0, upper_bound=ev_od[j])
      @variable(model_name, p_fl_dec[ j = 1:nTP, k = 1:nFl], start=0,lower_bound=0.0, upper_bound=-ev_ud[j])
# end
p_ch=nothing
p_dis=nothing
soc=nothing
# if nStr_active!=0

@variable(model_name, p_ch[ j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_ch_rat/sbase,lower_bound=0.0,upper_bound=array_storage[k].storage_ch_rat/sbase)
@variable(model_name, p_dis[ j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_dis_rat/sbase,lower_bound=0.0,upper_bound=array_storage[k].storage_dis_rat/sbase)
@variable(model_name, soc[ j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_e_rat/sbase,lower_bound=array_storage[k].storage_e_rat_min/sbase, upper_bound=array_storage[k].storage_e_rat/sbase)
# end
return v_sq, teta, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc
end

function variables_t_c(model_name)

    @variable(model_name, v_sq_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nBus], start=1.0)#,(start = 1.00)                                  # This procedure can be used to set the start values of all variables

@variable(model_name, teta_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], start=0.0)
# @variable(model_name, slack_p_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus, l=1:nBus], lower_bound=0)
# @variable(model_name, slack_n_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus, l=1:nBus], lower_bound=0)
# @variable(model_name, slack_v_p_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_v_n_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_pb_p_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_pb_n_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_rb_p_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)
# @variable(model_name, slack_rb_n_c[c = 1:nCont,s=1:nSc, t= 1:nTP, i=1:nBus], lower_bound=0)



@variable(model_name, pen_ws_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nRES], start=0.5*prof_PRES[i,j,k], lower_bound=0.0, upper_bound=prof_PRES[i,j,k])
@variable(model_name, pen_lsh_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nLoads], start=0.5*prof_ploads[k,j],lower_bound=0.0, upper_bound=abs.(prof_ploads[k,j]))
@variable(model_name, Pg_c[c = 1:nCont, i = 1:nSc, j = 1:nTP, k = 1:nGens])
@variable(model_name, Qg_c[c = 1:nCont, i = 1:nSc, j = 1:nTP, k = 1:nGens])
p_fl_inc_c=nothing
p_fl_dec_c=nothing
 # if nFl!=0
     @variable(model_name, p_fl_inc_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nFl], start=0,lower_bound=0.0, upper_bound=ev_od[j])
     @variable(model_name, p_fl_dec_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nFl], start=0,lower_bound=0.0, upper_bound=-ev_ud[j])
 # end
p_ch_c=nothing
p_dis_c=nothing
soc_c=nothing
# if nStr_active!=0
@variable(model_name, p_ch_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_ch_rat/sbase,lower_bound=0.0,upper_bound=array_storage[k].storage_ch_rat/sbase)
@variable(model_name, p_dis_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_dis_rat/sbase,lower_bound=0.0,upper_bound=array_storage[k].storage_dis_rat/sbase)
@variable(model_name, soc_c[c = 1:nCont,i = 1:nSc, j = 1:nTP, k = 1:nStr_active], start=0.5*array_storage[k].storage_e_rat/sbase,lower_bound=array_storage[k].storage_e_rat_min/sbase, upper_bound=array_storage[k].storage_e_rat/sbase)
# end
return v_sq_c, teta_c, Pg_c, Qg_c, pen_ws_c, pen_lsh_c, p_fl_inc_c, p_fl_dec_c,p_ch_c,p_dis_c,soc_c#,slack_pb_p_c,slack_pb_n_c

end

# (v_sq,teta,Pg,Qg,v_sq_c,teta_c,Pg_c,Qg_c)=variables_t(1, model_name)


function voltage_cons_t_n(model_name, indicator)
    for t=1:nTP,i=1:nBus
    if  nw_buses[i].bus_type==3
        fix(teta[t,i],0)
    # else
    #      set_lower_bound(teta[s,t,i],-pi/2)
    #      set_upper_bound(teta[s,t,i],+pi/2)
    end
end
    if indicator==1

        vol_n1=@constraint(model_name, [t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet)[1])], v_sq[t,i]<=(nw_buses[i].bus_vmax)^2)
        vol_n2=@constraint(model_name, [t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet)[1])], (nw_buses[i].bus_vmin)^2<=v_sq[t,i])
        # vol_n1=0
        # vol_n2=@constraint(model_name, [t=1:nTP,i=1:nBus], 0<=v_sq[t,i])
# vol_n1=@constraint(model_name, [s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet))], v_sq[s,t,i]<=(nw_buses[i].bus_vmax)^2)
# vol_n1=@constraint(model_name, [s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet))], v_sq[s,t,i]==(nw_gens[indexin(i, bus_data_gsheet)[1]].gen_V_set)^2)
# vol_n1=@constraint(model_name, [s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet))], v_sq[s,t,i]==(nw_gens[indexin(i, bus_data_gsheet)[1]].gen_V_set)^2)
# vol_n1=0
# vol_n2=0
vol_n3=0
vol_n4=0
elseif indicator==2
# vol_n1=@constraint(model_name, [s=1:nSc,t=1:nTP,i=1:nBus], v_sq[s,t,i]+slack_v_p[s,t,i]-slack_v_n[s,t,i]<=(nw_buses[i].bus_vmax)^2)
# vol_n2=@constraint(model_name, [s=1:nSc,t=1:nTP,i=1:nBus], (nw_buses[i].bus_vmin)^2<=v_sq[s,t,i]+slack_v_p[s,t,i]-slack_v_n[s,t,i])
vol_n1=@constraint(model_name, [t=1:nTP,i=1:nBus], v_sq[t,i]<=(nw_buses[i].bus_vmax)^2)
vol_n2=@constraint(model_name, [t=1:nTP,i=1:nBus], (nw_buses[i].bus_vmin)^2<=v_sq[t,i])

vol_n3=0
vol_n4=0
elseif indicator==3 || indicator==4
    vol_n1=@constraint(model_name, [t=1:nTP,i=1:nBus;!haskey(voltage_violation["vol_viol_val_dic_min"],[t,i])], v_sq[t,i]<=(nw_buses[i].bus_vmax)^2)
    vol_n2=@constraint(model_name, [t=1:nTP,i=1:nBus;!haskey(voltage_violation["vol_viol_val_dic_min"],[t,i])], (nw_buses[i].bus_vmin)^2<=v_sq[t,i])

vol_n3=@constraint(model_name,
                  [t=1:nTP,i=1:nBus;haskey(voltage_violation["vol_viol_val_dic_max"],[t,i])],
                  v_sq[t,i]<=(nw_buses[i].bus_vmax-voltage_violation["vol_viol_val_dic_max"][[t,i]])^2
)
vol_n4=@constraint(model_name,
                  [t=1:nTP,i=1:nBus;haskey(voltage_violation["vol_viol_val_dic_min"],[t,i])],
                  (nw_buses[i].bus_vmin+voltage_violation["vol_viol_val_dic_min"][[t,i]])^2<=v_sq[t,i]
)
end
return vol_n1,vol_n2,vol_n3,vol_n4
end

function voltage_cons_t_c(model_name, indicator)   #indicator means iteration
    for c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus
    if  nw_buses[i].bus_type==3
        fix(teta_c[c,s,t,i],0)
        # @constraint(model_name,teta_c[c,s,t,i]==0)
    # else
    #      set_lower_bound(teta[s,t,i],-pi/2)
    #      set_upper_bound(teta[s,t,i],+pi/2)
    end
end
    if indicator==1
                                                      # ~isnothing(indexin(i, bus_data_gsheet))
vol_c1=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet)[1]) ], v_sq_c[c,s,t,i]<=(nw_buses[i].bus_vmax+v_relax_factor_max)^2)
vol_c2=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet)[1]) ], (nw_buses[i].bus_vmin-v_relax_factor_min)^2<=v_sq_c[c,s,t,i])
# vol_c1=0
# vol_c2=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus], 0<=v_sq_c[c,s,t,i])

# vol_c1=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus;  ~isnothing(indexin(i, bus_data_gsheet))], v_sq_c[c,s,t,i]==(nw_gens[indexin(i, bus_data_gsheet)[1]].gen_V_set)^2)
# vol_c2=0
vol_c3=0
vol_c4=0
# return vol_c1,vol_c2,
elseif indicator==2
    # vol_c1=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus], v_sq_c[c,s,t,i]+slack_v_p_c[c,s,t,i]-slack_v_n_c[c,s,t,i]<=(nw_buses[i].bus_vmax+v_relax_factor_max)^2)
    # vol_c2=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus], (nw_buses[i].bus_vmin-v_relax_factor_min)^2<=v_sq_c[c,s,t,i]+slack_v_p_c[c,s,t,i]-slack_v_n_c[c,s,t,i])
    vol_c1=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus], v_sq_c[c,s,t,i]<=(nw_buses[i].bus_vmax+v_relax_factor_max)^2)
    vol_c2=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus], (nw_buses[i].bus_vmin-v_relax_factor_min)^2<=v_sq_c[c,s,t,i])

    vol_c3=0
    vol_c4=0


elseif indicator==3 || indicator==4
    vol_c1=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus;!haskey(voltage_violation["vol_viol_val_c_dic_min"],[c,s,t,i])], v_sq_c[c,s,t,i]<=(nw_buses[i].bus_vmax+v_relax_factor_max)^2)
    vol_c2=@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus;!haskey(voltage_violation["vol_viol_val_c_dic_min"],[c,s,t,i])], (nw_buses[i].bus_vmin-v_relax_factor_min)^2<=v_sq_c[c,s,t,i])
vol_c3=@constraint(model_name,
                  [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus,;haskey(voltage_violation["vol_viol_val_c_dic_max"],[c,s,t,i])],
                  v_sq_c[c,s,t,i]<=((nw_buses[i].bus_vmax+v_relax_factor_max-voltage_violation["vol_viol_val_c_dic_max"][[c,s,t,i]]))^2
)
vol_c4=@constraint(model_name,
                  [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nBus,;haskey(voltage_violation["vol_viol_val_c_dic_min"],[c,s,t,i])],
                  ((nw_buses[i].bus_vmin-v_relax_factor_min+voltage_violation["vol_viol_val_c_dic_min"][[c,s,t,i]]))^2<=v_sq_c[c,s,t,i]
)
end
return vol_c1,vol_c2,vol_c3,vol_c4
# end
end

function gen_limits_t_n(model_name)

    for t=1:nTP,i=1:nGens
        if pg_min[i]==0 && pg_max[i]==0
         fix(Pg[t,i],0)
       else
 set_lower_bound(Pg[t,i],pg_min[i])
 set_upper_bound(Pg[t,i],pg_max[i])
    end
end
for t=1:nTP,i=1:nGens
    if qg_min[i]==0 && qg_max[i]==0
     fix(Qg[t,i],0)
   else
set_lower_bound(Qg[t,i],qg_min[i])
set_upper_bound(Qg[t,i],qg_max[i])
end
end
    #  if    nw_buses[bus_data_gsheet[i]].bus_type!=3
    #          fix(Pg[s,t,i],nw_gens[i].gen_Pg_avl)
    # end

end

function gen_limits_t_c(model_name)

    for c=1:nCont, s=1:nSc,t=1:nTP,i=1:nGens
        if pg_min[i]==0 && pg_max[i]==0
         fix(Pg_c[c,s,t,i],0)
       else
 set_lower_bound(Pg_c[c,s,t,i],pg_min[i])
 set_upper_bound(Pg_c[c,s,t,i],pg_max[i])
    end
end
for c=1:nCont,s=1:nSc,t=1:nTP,i=1:nGens
    if qg_min[i]==0 && qg_max[i]==0
     fix(Qg_c[c,s,t,i],0)
   else
set_lower_bound(Qg_c[c,s,t,i],qg_min[i])
set_upper_bound(Qg_c[c,s,t,i],qg_max[i])
end
end
    #  if    nw_buses[bus_data_gsheet[i]].bus_type!=3
    #          fix(Pg[s,t,i],nw_gens[i].gen_Pg_avl)
    # end

end

function FL_cons_normal_t(model_name)
    # @constraint(model_name,[i=1:nFl],sum(p_fl_inc[t,i] for t in 1:nTP)==sum(p_fl_dec[t,i] for t in 1:nTP))
    @constraint(model_name,[t=1:nTP,i=1:nFl],p_fl_inc[t,i]/(ev_od[t])+p_fl_dec[t,i]/(-ev_ud[t]) <=1)
end

function FL_cons_contin_t(model_name)
    # @constraint(model_name,[c=1:nCont,s=1:nSc,i=1:nFl],sum(p_fl_inc_c[c,s,t,i] for t in 1:nTP)-sum(p_fl_dec_c[c,s,t,i] for t in 1:nTP)==0)
    @constraint(model_name,[c=1:nCont,s=1:nSc,t=1:nTP,i=1:nFl],p_fl_inc_c[c,s,t,i]/(ev_od[t])+p_fl_dec_c[c,s,t,i]/(-ev_ud[t]) <=1)
end

function storage_cons_normal_t(model_name)
@constraint(model_name,
            [t=1:nTP,j = 1:nStr_active; t==1],
            soc[t,j]==array_storage[j].storage_e_initial/sbase
            +p_ch[t,j]*array_storage[j].storage_ch_eff
            -p_dis[t,j]*(array_storage[j].storage_dis_eff^-1)
            )
@constraint(model_name,
           [t=1:nTP,j = 1:nStr_active; t!=1],
           soc[t,j]==soc[t-1,j]
           +p_ch[t,j]*array_storage[j].storage_ch_eff
           -p_dis[t,j]*(array_storage[j].storage_dis_eff^-1)
                        )

@constraint(model_name,
           [t=1:nTP,j = 1:nStr_active],
           p_ch[t,j]/(array_storage[j].storage_ch_rat/sbase)+p_dis[t,j]/(array_storage[j].storage_dis_rat/sbase)<=1
           )
@constraint(model_name,
          [ j = 1:nStr_active],
          soc[nTP,j]==array_storage[j].storage_e_initial/sbase
          )
end
function storage_cons_contin_t(model_name)
@constraint(model_name,
            [c=1:nCont,s=1:nSc,t=1:nTP,j = 1:nStr_active; t==1],
            soc_c[c,s,t,j]==array_storage[j].storage_e_initial/sbase
            +p_ch_c[c,s,t,j]*array_storage[j].storage_ch_eff
            -p_dis_c[c,s,t,j]*(array_storage[j].storage_dis_eff^-1)
            )
@constraint(model_name,
           [c=1:nCont,s=1:nSc,t=1:nTP,j = 1:nStr_active; t!=1],
           soc_c[c,s,t,j]==soc_c[c,s,t-1,j]
           +p_ch_c[c,s,t,j]*array_storage[j].storage_ch_eff
           -p_dis_c[c,s,t,j]*(array_storage[j].storage_dis_eff^-1)
                        )

@constraint(model_name,
           [c=1:nCont,s=1:nSc,t=1:nTP,j = 1:nStr_active],
           p_ch_c[c,s,t,j]/(array_storage[j].storage_ch_rat/sbase)+p_dis_c[c,s,t,j]/(array_storage[j].storage_dis_rat/sbase)<=1
           )

@constraint(model_name,
          [c=1:nCont,s=1:nSc, j = 1:nStr_active],
          soc_c[c,s,nTP,j]==array_storage[j].storage_e_initial/sbase
          )
end



function trans_map_t(nBus,node_data_trans)
    from_to_map_t=Dict()
    for i in 1:nBus

     if  ~isempty(node_data_trans[i,1].node_num)
       for j in 1:size(node_data_trans[i,1].node_num,1)
           from_node=findall(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
           to_node  =findall(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)

           check_idx= intersect(from_node,to_node)
           push!(from_to_map_t, [i,j]=> check_idx)
       end
   end
end

return from_to_map_t
end
from_to_map_t=trans_map_t(nBus,node_data_trans)

function line_expression_t_n(model_name,from_to_map_t, loss_indicator)  # if loss indicator is one it consider loss terms

pinj_dict=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
qinj_dict=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
pinj_dict_l=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
qinj_dict_l=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
ploss_dic=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
ploss_trans_dic=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
ploss_check=[]
 # for s in 1:nSc
    for t in 1:nTP

        for i in 1:nBus
            # for i in [47]
            idx_nd_nw_buses = indexin(i,rdata_buses[:,1])
            idx_nd_nw_buses = idx_nd_nw_buses[1,1]

        if  ~isempty(node_data[i,1].node_num)


            for j in 1:size(node_data[i,1].node_num,1)                                                # length of each node vector in 'node_data' variable

                gij_line    = node_data[i,1].node_gij_sr[j,1]
                bij_line    = node_data[i,1].node_bij_sr[j,1]
                cnctd_nd    = node_data[i,1].node_cnode[j,1]
                idx_cnctd_nd = indexin(cnctd_nd,rdata_buses[:,1])
                idx_cnctd_nd = idx_cnctd_nd[1,1]
                gij_line_sh = node_data[i,1].node_gij_sh[j,1]
                bij_line_sh = node_data[i,1].node_bij_sh[j,1]
                s_max      =  node_data[i,1].node_smax[j,1]
                # i_from = indexin(idx_nd_nw_buses,idx_from_line)
                # i_to   = indexin(idx_cnctd_nd,idx_to_line)
                # line_identifier  = intersect(i_from,i_to)

                pinj_ij_sh      =@expression(model_name, (gij_line_sh/2)*v_sq[t,idx_nd_nw_buses])
                pinj_ij_sr1     =@expression(model_name,(gij_line/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd])-bij_line*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]) )

                qinj_ij_sh      =@expression(model_name, -(bij_line_sh/2)*v_sq[t,idx_nd_nw_buses] )
                qinj_ij_sr1     =@expression(model_name,(-bij_line/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd])-gij_line*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]) )

                if loss_indicator==1
                lf_tetap=@expression(model_name, gij_line*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd])-0.5*gij_line*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2) )
                lf_voltp=@expression(model_name, gij_line*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd])-0.5*gij_line*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2) )
                # constantp=(-0.5*gij_line*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2) )

                ploss           =@expression(model_name,      lf_tetap+lf_voltp)


                lf_tetaq=@expression(model_name, (-bij_line)*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd])-0.5*(-bij_line)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2) )
                lf_voltq=@expression(model_name, (-bij_line)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd])-0.5*(-bij_line)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2) )
                # constantq=(-0.5*(-bij_line)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2) )
              #   lf_tetaq=( (-bij_line)*(teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]) )
              #   lf_voltq=( (-bij_line)*((v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])/(v0_n[t,idx_nd_nw_buses]+v0_n[t,idx_cnctd_nd]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd]) )
              #   constantq=(-0.5*(-bij_line)*((teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )^2+(v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])^2) )

              qloss           = @expression(model_name,      lf_tetaq+lf_voltq)

               pij =   @expression(model_name,pinj_ij_sh+pinj_ij_sr1
               +ploss
               )
               qij =   @expression(model_name,qinj_ij_sh+qinj_ij_sr1
               +qloss
               )
                                        push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                        push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                        push!(pinj_dict_l,  [t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                        push!(qinj_dict_l,  [t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                        push!(ploss_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd] => lf_tetap+lf_voltp) #becasue the vol angle term should be positive
            elseif loss_indicator==0
                pij =   @expression(model_name,pinj_ij_sh+pinj_ij_sr1
                # +ploss
                )
                qij =   @expression(model_name,qinj_ij_sh+qinj_ij_sr1
                # +qloss
                )
                                         push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                         push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                         push!(pinj_dict_l,  [t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                         push!(qinj_dict_l,  [t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                         push!(ploss_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd] => 0)
            end
            end
       end
        if ~isempty(node_data_trans[i,1].node_num)
            for j in 1:size(node_data_trans[i,1].node_num,1)                                                # length of each node vector in 'node_data' variable
                gij_line_transf    = node_data_trans[i,1].node_gij_sr[j,1]
                bij_line_transf    = node_data_trans[i,1].node_bij_sr[j,1]
                cnctd_nd = node_data_trans[i,1].node_cnode[j,1]
                idx_cnctd_nd_trans = indexin(cnctd_nd,rdata_buses[:,1])
                idx_cnctd_nd_trans = idx_cnctd_nd_trans[1,1]
                gij_line_sh_transf = node_data_trans[i,1].node_gij_sh[j,1]
                bij_line_sh_transf = node_data_trans[i,1].node_bij_sh[j,1]
                tratio             = 1/node_data_trans[i,1].node_tratio[j,1]
                # from_node=findall(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
                # to_node  =findall(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)
                  # check_idx= intersect(from_node,to_node)
                check_idx= values(from_to_map_t[[i,j]])
                if ~isempty(check_idx)  #this means from
                pinj_ij_sh      =@expression(model_name, (gij_line_sh_transf/2)*v_sq[t,idx_nd_nw_buses])
                pinj_ij_sr1     =@expression(model_name, gij_line_transf*(tratio^2-(tratio/2))*v_sq[t,idx_nd_nw_buses]-(gij_line_transf/2)*tratio*v_sq[t,idx_cnctd_nd_trans]-bij_line_transf*tratio*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans]) )
                # pinj_ij_sr1     =(gij_line_transf/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-bij_line_transf*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])


                qinj_ij_sh      = @expression(model_name,-(bij_line_sh_transf/2 )*v_sq[t,idx_nd_nw_buses])
                qinj_ij_sr1     =@expression(model_name,(-bij_line_transf)*(tratio^2-(tratio/2))*v_sq[t,idx_nd_nw_buses]+(bij_line_transf/2)*tratio*v_sq[t,idx_cnctd_nd_trans]-gij_line_transf*tratio*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans]))
                # qinj_ij_sr1     =(-bij_line_transf/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-gij_line_transf*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])


                   if loss_indicator==1
                lf_tetap=@expression(model_name, gij_line_transf*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2) )
                lf_voltp=@expression(model_name, gij_line_transf*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd_trans]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
                # constantp=(-0.5*gij_line_transf*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
                ploss           = @expression(model_name,     lf_tetap+lf_voltp)

                lf_tetaq=@expression(model_name, (-bij_line_transf)*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2) )
                lf_voltq=@expression(model_name, (-bij_line_transf)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd_trans]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
                # constantq=(-0.5*(-bij_line_transf)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
              #   lf_tetaq=( (-bij_line)*(teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]) )
              #   lf_voltq=( (-bij_line)*((v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])/(v0_n[t,idx_nd_nw_buses]+v0_n[t,idx_cnctd_nd]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd]) )
              #   constantq=(-0.5*(-bij_line)*((teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )^2+(v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])^2) )
              #
              # #
              qloss           =  @expression(model_name,     (lf_tetaq+lf_voltq))

              pijt1 =   @expression(model_name,pinj_ij_sh+pinj_ij_sr1
              +tratio*ploss
              )
              qijt1 =   @expression(model_name,qinj_ij_sh+qinj_ij_sr1
              +tratio*qloss
              )

               push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
               push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
               push!(ploss_trans_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => lf_tetap+lf_voltp)
           elseif loss_indicator==0
               pijt1 =   @expression(model_name,pinj_ij_sh+pinj_ij_sr1
               # +tratio*ploss
               )
               qijt1 =   @expression(model_name,qinj_ij_sh+qinj_ij_sr1
               # +tratio*qloss
               )

                push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
                push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
                push!(ploss_trans_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => 0)
           end

            elseif isempty(check_idx)
                pinj_ij_sh      =@expression(model_name, (gij_line_sh_transf/2)*v_sq[t,idx_nd_nw_buses])
                pinj_ij_sr1     =@expression(model_name, gij_line_transf*(1-(tratio/2))*v_sq[t,idx_nd_nw_buses]-tratio*(gij_line_transf/2)*v_sq[t,idx_cnctd_nd_trans]-bij_line_transf*tratio*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans]) )
                # pinj_ij_sr1     =(gij_line_transf/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-bij_line_transf*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])



                qinj_ij_sh      =@expression(model_name, -(bij_line_sh_transf/2 )*v_sq[t,idx_nd_nw_buses] )
                qinj_ij_sr1     = @expression(model_name,(-bij_line_transf)*(1-(tratio/2))*v_sq[t,idx_nd_nw_buses]+(bij_line_transf/2)*tratio*v_sq[t,idx_cnctd_nd_trans]-gij_line_transf*tratio*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans]) )
                # qinj_ij_sr1     =(-bij_line_transf/2)*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-gij_line_transf*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])
                  if loss_indicator==1
                lf_tetap=@expression(model_name, gij_line_transf*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2) )
                lf_voltp=@expression(model_name, gij_line_transf*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd_trans]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
                # constantp=(-0.5*gij_line_transf*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )

                ploss           =  @expression(model_name,    lf_tetap+lf_voltp )

                lf_tetaq=@expression(model_name, (-bij_line_transf)*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2) )
                lf_voltq=@expression(model_name, (-bij_line_transf)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd_trans]]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
                # constantq=(-0.5*(-bij_line_transf)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd_trans]] )^2+(v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd_trans]])^2) )
              #   lf_tetaq=( (-bij_line)*(teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )*(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]) )
              #   lf_voltq=( (-bij_line)*((v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])/(v0_n[t,idx_nd_nw_buses]+v0_n[t,idx_cnctd_nd]))*(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd]) )
              #   constantq=(-0.5*(-bij_line)*((teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )^2+(v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])^2) )

              qloss           =   @expression(model_name,    lf_tetaq+lf_voltq )

              pijt1 =   @expression(model_name,pinj_ij_sh+pinj_ij_sr1
              +tratio*ploss
              )

              qijt1 =   @expression(model_name,qinj_ij_sh+qinj_ij_sr1
              +tratio*qloss
              )

              push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
              push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
              push!(ploss_trans_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => lf_tetap+lf_voltp)

          elseif loss_indicator==0
              pijt1 =  @expression(model_name,pinj_ij_sh+pinj_ij_sr1
              # +tratio*ploss
              )

              qijt1 =  @expression(model_name,qinj_ij_sh+qinj_ij_sr1
              # +tratio*qloss
              )

              push!(pinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
              push!(qinj_dict,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
              push!(ploss_trans_dic,  [t,idx_nd_nw_buses,idx_cnctd_nd_trans] => 0)
          end
           end
       end
        end
    end
end
# end
return pinj_dict,pinj_dict_l,ploss_dic,qinj_dict,qinj_dict_l,ploss_trans_dic

end


function line_expression_t_c(model_name,from_to_map_t,loss_indicator)
pinj_dict_c=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
qinj_dict_c=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
pinj_dict_l_c=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
qinj_dict_l_c=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
ploss_c_dict=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
ploss_trans_dic_c=Dict{Array{Int64,1}, GenericAffExpr{Float64,VariableRef}}()
# v0_c=first_pf_cont_vmag
# teta0_c=first_pf_cont_vang

# @allocated(
ploss_check_c=[]
 for c in 1:nCont
    for s in 1:nSc
        for t in 1:nTP
            for i in 1:nBus

            # nd      = node_data_contin[c][i].node_num_c                                    # Node num is independant of time period and scenario
            # nd_num  = unique(nd)
            # nd_num  = nd_num[1,1]

            # idx_nd_nw_buses = indexin(i,rdata_buses[:,1])
            # idx_nd_nw_buses = idx_nd_nw_buses[1,1]
            idx_nd_nw_buses= i
            # idx_fr_trans =indexin(i,idx_from_trans)
            if  ~isempty(node_data_contin[c][i].node_num_c)


                    for j in 1:size(node_data_contin[c][i].node_num_c,1)                                                # length of each node vector in 'node_data' variable

                        gij_line    = node_data_contin[c][i].node_gij_sr_c[j]
                        bij_line    = node_data_contin[c][i].node_bij_sr_c[j]
                        cnctd_nd    = node_data_contin[c][i].node_cnode_c[j]
                        # idx_cnctd_nd = indexin(cnctd_nd,rdata_buses[:,1])
                        idx_cnctd_nd = cnctd_nd[1,1]
                        gij_line_sh = node_data_contin[c][i].node_gij_sh_c[j]
                        bij_line_sh = node_data_contin[c][i].node_bij_sh_c[j]
                        s_max      =  node_data_contin[c][i].node_smax_c[j]

                        pinj_ij_sh      = @expression(model_name,(gij_line_sh/2)*v_sq_c[c,s,t,idx_nd_nw_buses] )       # Line shunt conductance (Must be divided by 2)
                        pinj_ij_sr1     = @expression(model_name,
                                                        (gij_line/2)*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])
                                                        -bij_line*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd])
                                                         )


                        qinj_ij_sh      = @expression(model_name,-(bij_line_sh/2 )*v_sq_c[c,s,t,idx_nd_nw_buses] )      # Line shunt susceptance (Must be divided by 2)
                        qinj_ij_sr1     = @expression(model_name,
                                                               (-bij_line/2)*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])
                                                               -gij_line*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd])
                        )

                          if loss_indicator==1

                        lf_tetap=@expression(model_name, gij_line*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )^2) )
                        lf_voltp=@expression(model_name, gij_line*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])^2)  )
                        # constantp=(-0.5*gij_line*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])^2) )
                        #     # *M[node_data[i,1].node_iline[1],idx_nd_nw_buses]
                        # # @constraint(model_name, 0<=slack_c[c,s,t,i]+gij_line*((v0[t,idx_nd_nw_buses]-v0[t,idx_cnctd_nd])/(v0[t,idx_nd_nw_buses]+v0[t,idx_cnctd_nd]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*(v0[t,idx_nd_nw_buses]-v0[t,idx_cnctd_nd])^2)
                        #
                        #
                        ploss           =@expression(model_name,
                                                lf_tetap
                                                +
                                                lf_voltp
                                                # +
                                                # constantp
                                                              )
                                # @constraint(model_name, 0<=ploss+slack_c[c,s,t,i])
                     #            @constraint(model_name, 0<=ploss)
                     # push!(ploss_check_c,ploss)
                     lf_tetaq=@expression(model_name, (-bij_line)*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd])-0.5*(-bij_line)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )^2) )
                     lf_voltq=@expression(model_name, (-bij_line)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])-0.5*(-bij_line)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])^2) )
                     # constantq=(-0.5*(-bij_line)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])^2) )

                      #
                      qloss           =@expression(model_name,
                                              lf_tetaq
                                              +
                                              lf_voltq
                                              # +
                                              # constantq
                                                              )

                                pij = @expression(model_name,
                                                         +pinj_ij_sh
                                                         +pinj_ij_sr1
                                                        +ploss
                                                        )
                                qij = @expression(model_name,
                                                        +qinj_ij_sh
                                                        +qinj_ij_sr1
                                                        +qloss
                                                        )
                                                        push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                                        push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                                        push!(pinj_dict_l_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                                        push!(qinj_dict_l_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                                        push!(ploss_c_dict,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => lf_voltp)

                    elseif loss_indicator==0
                        pij = @expression(model_name,
                                                 +pinj_ij_sh
                                                 +pinj_ij_sr1
                                                # +ploss
                                                )
                        qij = @expression(model_name,
                                                +qinj_ij_sh
                                                +qinj_ij_sr1
                                                # +qloss
                                                )
                                                push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                                push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                                push!(pinj_dict_l_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => pij)
                                                push!(qinj_dict_l_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => qij)
                                                push!(ploss_c_dict,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => 0)

                       end

                end
               end
                if ~isempty(node_data_trans[i,1].node_num)
                    # idx_t_trans=idx_t_trans[1]
                    for j in 1:size(node_data_trans[i,1].node_num,1)                                                # length of each node vector in 'node_data' variable
                        gij_line_transf    = node_data_trans[i,1].node_gij_sr[j,1]
                        bij_line_transf    = node_data_trans[i,1].node_bij_sr[j,1]
                        cnctd_nd = node_data_trans[i,1].node_cnode[j,1]
                        # idx_cnctd_nd_trans = indexin(cnctd_nd,rdata_buses[:,1])
                        idx_cnctd_nd_trans = cnctd_nd[1,1]
                        gij_line_sh_transf = node_data_trans[i,1].node_gij_sh[j,1]
                        bij_line_sh_transf = node_data_trans[i,1].node_bij_sh[j,1]
                        tratio             = 1/node_data_trans[i,1].node_tratio[j,1]
                        # from_node=indexin(node_data_trans[i,1].node_num[j,1], idx_from_trans)
                        # from_node=findall(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
                        # # to_node  =indexin(node_data_trans[i,1].node_cnode[j,1], idx_to_trans)
                        # to_node  =findall(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)
                        #
                        # check_idx= intersect(from_node,to_node)
                        check_idx= values(from_to_map_t[[i,j]])
                        if ~isempty(check_idx)  #this means from
                        pinj_ij_sh      = @expression(model_name,(gij_line_sh_transf/2)*v_sq_c[c,s,t,idx_nd_nw_buses])
                        pinj_ij_sr1     = @expression(model_name, gij_line_transf*(tratio^2-(tratio/2))*v_sq_c[c,s,t,idx_nd_nw_buses]-(gij_line_transf/2)*tratio*v_sq_c[c,s,t,idx_cnctd_nd_trans]-bij_line_transf*tratio*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans])  )

                        qinj_ij_sh      =@expression(model_name, -(bij_line_sh_transf/2 )*v_sq_c[c,s,t,idx_nd_nw_buses])
                        qinj_ij_sr1     =@expression(model_name,(-bij_line_transf)*(tratio^2-(tratio/2))*v_sq_c[c,s,t,idx_nd_nw_buses]+(bij_line_transf/2)*tratio*v_sq_c[c,s,t,idx_cnctd_nd_trans]-gij_line_transf*tratio*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans]))

                          if loss_indicator==1
                        lf_tetap=@expression(model_name, gij_line_transf*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2) )
                        lf_voltp=@expression(model_name, gij_line_transf*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd_trans]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        # constantp=(-0.5*gij_line_transf*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        # # *M[node_data[i,1].node_iline[1],idx_nd_nw_buses]
                        # # @constraint(model_name,0<=slack[t,i]+ gij_line*((v0[t,idx_nd_nw_buses]-v0[t,idx_cnctd_nd])/(v0[t,idx_nd_nw_buses]+v0[t,idx_cnctd_nd]))*M[node_data[i,1].node_iline[1],idx_nd_nw_buses]*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*(v0[t,idx_nd_nw_buses]-v0[t,idx_cnctd_nd])^2)
                        #  # push!(ploss_positive,positive_ploss )
                        #
                        ploss           =  @expression(model_name,    lf_tetap+lf_voltp)

                        lf_tetaq=@expression(model_name, (-bij_line_transf)*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2) )
                        lf_voltq=@expression(model_name,(-bij_line_transf)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd_trans]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        # constantq=(-0.5*(-bij_line_transf)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        #   lf_tetaq=( (-bij_line)*(teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd]) )
                        #   lf_voltq=( (-bij_line)*((v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])/(v0_n[t,idx_nd_nw_buses]+v0_n[t,idx_cnctd_nd]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd]) )
                        #   constantq=(-0.5*(-bij_line)*((teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )^2+(v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])^2) )
                        #
                        # #
                        qloss           =@expression(model_name,      lf_tetaq+lf_voltq)

                        pijt1 = @expression(model_name,  pinj_ij_sh+pinj_ij_sr1+tratio*ploss)
                        qijt1 = @expression(model_name,  qinj_ij_sh+qinj_ij_sr1+tratio*qloss)
                         push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
                         push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
                         push!(ploss_trans_dic_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => lf_voltp)
                     elseif loss_indicator==0
                         pijt1 = @expression(model_name,  pinj_ij_sh+pinj_ij_sr1)
                         qijt1 = @expression(model_name,  qinj_ij_sh+qinj_ij_sr1)
                          push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
                          push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
                          push!(ploss_trans_dic_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => 0)
                      end
                        elseif isempty(check_idx)
                        pinj_ij_sh      = @expression(model_name,(gij_line_sh_transf/2)*v_sq_c[c,s,t,idx_nd_nw_buses])
                        pinj_ij_sr1     = @expression(model_name,gij_line_transf*(1-(tratio/2))*v_sq_c[c,s,t,idx_nd_nw_buses]-tratio*(gij_line_transf/2)*v_sq_c[c,s,t,idx_cnctd_nd_trans]-bij_line_transf*tratio*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans]))

                        qinj_ij_sh      = @expression(model_name,-(bij_line_sh_transf/2 )*v_sq_c[c,s,t,idx_nd_nw_buses])
                        qinj_ij_sr1     = @expression(model_name,(-bij_line_transf)*(1-(tratio/2))*v_sq_c[c,s,t,idx_nd_nw_buses]+(bij_line_transf/2)*tratio*v_sq_c[c,s,t,idx_cnctd_nd_trans]-gij_line_transf*tratio*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans]))
                          if loss_indicator==1
                        lf_tetap=@expression(model_name, gij_line_transf*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2) )
                        lf_voltp=@expression(model_name, gij_line_transf*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd_trans]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd_trans])-0.5*gij_line_transf*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        # constantp=(-0.5*gij_line_transf*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        ploss           = @expression(model_name,     lf_tetap+lf_voltp)

                        lf_tetaq=@expression(model_name, (-bij_line_transf)*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2) )
                        lf_voltq=@expression(model_name, (-bij_line_transf)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd_trans]]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd_trans])-0.5*(-bij_line_transf)*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        # constantq=(-0.5*(-bij_line_transf)*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd_trans]] )^2+(v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd_trans]])^2) )
                        #   lf_tetaq=( (-bij_line)*(teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )*(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd]) )
                        #   lf_voltq=( (-bij_line)*((v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])/(v0_n[t,idx_nd_nw_buses]+v0_n[t,idx_cnctd_nd]))*(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd]) )
                        #   constantq=(-0.5*(-bij_line)*((teta0_n[t,idx_nd_nw_buses]-teta0_n[t,idx_cnctd_nd] )^2+(v0_n[t,idx_nd_nw_buses]-v0_n[t,idx_cnctd_nd])^2) )
                        qloss           = @expression(model_name,      lf_tetaq+lf_voltq)
                        pijt1 =@expression(model_name,  pinj_ij_sh+pinj_ij_sr1+tratio*ploss)
                        qijt1 = @expression(model_name,  qinj_ij_sh+qinj_ij_sr1+tratio*qloss)
                         push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
                         push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
                         push!(ploss_trans_dic_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => lf_voltp)
                     elseif loss_indicator==0
                         pijt1 = @expression(model_name,  pinj_ij_sh+pinj_ij_sr1)
                         qijt1 = @expression(model_name,  qinj_ij_sh+qinj_ij_sr1)
                          push!(pinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => pijt1)
                          push!(qinj_dict_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => qijt1)
                         push!(ploss_trans_dic_c,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd_trans] => 0)
                     end
                        end
                        end

        end
    end
 end
end
end
return pinj_dict_c, pinj_dict_l_c, ploss_c_dict, qinj_dict_c,qinj_dict_l_c,ploss_trans_dic_c

end


function power_balance_t_n(model_name)

 @constraint(model_name, active_power_balance_normal[ t in 1:nTP, b in 1:nBus],

       reduce(+, (Pg[t,i[1]] for i in indexin(b,bus_data_gsheet) if ~isnothing(indexin(b,bus_data_gsheet)[1])); init=0)
       +
       reduce(+, (prof_PRES[1,t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
       +
       reduce(+, (pen_lsh[t,i[1]] for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
       -
       reduce(+, (pen_ws[t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
       -
       reduce(+, (p_ch[t,i[1]] for i in indexin(b,nd_Str_active) if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)
       +
       reduce(+, (p_dis[t,i[1]] for i in indexin(b,nd_Str_active) if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)


    # + slack_pb_p[t,b]-slack_pb_n[t,b]

        ==reduce(+, (pinj_dict[[t,b,j]] for j in node_data[b].node_cnode if ~isempty(node_data[b].node_num)); init=0)
        +
        reduce(+, (pinj_dict[[t,b,j]] for j in node_data_trans[b,1].node_cnode if ~isempty(node_data_trans[b,1].node_num)); init=0)
        +
        reduce(+, (prof_ploads[i[1],t]  for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
        +
        reduce(+, (p_fl_inc[t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
        -
        reduce(+, (p_fl_dec[t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
            )

            # @constraint(model_name, tot_active_power_balance_normal[ t in 1:nTP],
            #
            #       sum(
            #       reduce(+, (Pg[t,i[1]] for i in indexin(b,bus_data_gsheet) if ~isnothing(indexin(b,bus_data_gsheet)[1])); init=0)
            #       +
            #       reduce(+, (prof_PRES[1,t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
            #       +
            #       reduce(+, (pen_lsh[t,i[1]] for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
            #       -
            #       reduce(+, (pen_ws[t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
            #       -
            #       reduce(+, (p_ch[t,i[1]] for i in indexin(b,nd_Str_active) if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)
            #       +
            #       reduce(+, (p_dis[t,i[1]] for i in indexin(b,nd_Str_active) if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)
            #          for b in 1:nBus)
            #              >=
            #              sum(
            #              reduce(+, (prof_ploads[i[1],t]  for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
            #              +
            #              reduce(+, (p_fl_inc[t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
            #              -
            #              reduce(+, (p_fl_dec[t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
            #                  for b in 1:nBus)
            #                      )



  @constraint(model_name, reactive_power_balance_normal[ t in 1:nTP, b in 1:nBus],

       reduce(+, (Qg[t,i[1]] for i in indexin(b,bus_data_gsheet) if ~isnothing(indexin(b,bus_data_gsheet)[1])); init=0)
       # +
       # reduce(+, (tan(acos(power_factor))*pen_lsh[t,i[1]] for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
        # + slack_rb_p[t,b]-slack_rb_n[t,b]
        ==reduce(+, (qinj_dict[[t,b,j]] for j in node_data[b].node_cnode if ~isempty(node_data[b].node_num)); init=0)
        +
        reduce(+, (qinj_dict[[t,b,j]] for j in node_data_trans[b,1].node_cnode if ~isempty(node_data_trans[b,1].node_num)); init=0)
        +
        reduce(+, (prof_qloads[i[1],t]  for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
        -
        reduce(+, (nw_shunts[i[1]].shunt_bsh0  for i in indexin(b,rdata_shunts[:,1]) if ~isnothing(indexin(b,rdata_shunts[:,1])[1])); init=0)

            )

return active_power_balance_normal,reactive_power_balance_normal
end


function power_balance_t_c(model_name)
    @constraint(model_name, active_power_balance_contin[c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus],

    boolean_func(b,bus_data_gsheet, Pg_c[c,s,t,:])
    +
    boolean_func(b,RES_bus, prof_PRES[s,t,:])
    +
    boolean_func(b,bus_data_lsheet, pen_lsh_c[c,s,t,:])
    -
    boolean_func(b,RES_bus, pen_ws_c[c,s,t,:])
    -
    boolean_func(b,nd_Str_active, p_ch_c[c,s,t,:])
    +
    boolean_func(b,nd_Str_active,p_dis_c[c,s,t,:] )
    # +
    # slack_pb_p_c[c,s,t,b]
    # -
    # slack_pb_n_c[c,s,t,b]
     ==boolean_func_injection(c,s,t,b,pinj_dict_c,node_data_contin[c][b].node_cnode_c)
     +
     boolean_func_injection(c,s,t,b,pinj_dict_c,node_data_trans[b,1].node_cnode)
     +
     boolean_func(b,bus_data_lsheet,prof_ploads[:,t] )
     +
     boolean_func(b,nd_fl,p_fl_inc_c[c,s,t,:] )
     -
     boolean_func(b,nd_fl,p_fl_dec_c[c,s,t,:] )
         )

         # @constraint(model_name, tot_active_power_balance_contin[c in 1:nCont, s in 1:nSc, t in 1:nTP],
         #
         #       sum(
         #       boolean_func(b,bus_data_gsheet, Pg_c[c,s,t,:])
         #       +
         #       boolean_func(b,RES_bus, prof_PRES[s,t,:])
         #       +
         #       boolean_func(b,bus_data_lsheet, pen_lsh_c[c,s,t,:])
         #       -
         #       boolean_func(b,RES_bus, pen_ws_c[c,s,t,:])
         #       -
         #       boolean_func(b,nd_Str_active, p_ch_c[c,s,t,:])
         #       +
         #       boolean_func(b,nd_Str_active,p_dis_c[c,s,t,:] )
         #
         #
         #        for b in 1:nBus)>=
         #              sum(
         #              boolean_func(b,bus_data_lsheet,prof_ploads[:,t] )
         #              +
         #              boolean_func(b,nd_fl,p_fl_inc_c[c,s,t,:] )
         #              -
         #              boolean_func(b,nd_fl,p_fl_dec_c[c,s,t,:] )
         #
         #              for b in 1:nBus)
         #                      )
 @constraint(model_name, reactive_power_balance_contin[c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus],
           boolean_func(b,bus_data_gsheet,Qg_c[c,s,t,:])
           # +
           # boolean_func(b,bus_data_lsheet, tan(acos(power_factor))*pen_lsh_c[c,s,t,:])
           ==
           boolean_func_injection(c,s,t,b,qinj_dict_c,node_data_contin[c][b].node_cnode_c)
           # reduce(+, (qinj_dict_c[[c,s,t,b,j]] for j in node_data_contin[c][b].node_cnode_c if ~isempty(node_data_contin[c][b].node_num_c)); init=0)
           +
           # reduce(+, (qinj_dict_c[[c,s,t,b,node_data_trans[b,1].node_cnode[j]]] for j in 1:size(node_data_trans[b,1].node_num,1) if ~isempty(node_data_trans[b,1].node_num)); init=0)
           boolean_func_injection(c,s,t,b,qinj_dict_c,node_data_trans[b,1].node_cnode)
           # reduce(+, (qinj_dict_c[[c,s,t,b,j]] for j in node_data_trans[b,1].node_cnode if ~isempty(node_data_trans[b,1].node_num)); init=0)
           # sum(qinj_dict_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]] for j in 1:size(node_data_contin[c][b].node_num_c,1) )
           +
           boolean_func(b,bus_data_lsheet,prof_qloads[:,t])
           -
           # boolean_func(b,rdata_shunts[:,1],nw_shunts[:].shunt_bsh0)

           reduce(+, (nw_shunts[i[1]].shunt_bsh0  for i in indexin(b,rdata_shunts[:,1]) if ~isnothing(indexin(b,rdata_shunts[:,1])[1])); init=0)

               )

# @constraint(model_name, active_power_balance_contin[c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus],
#
# reduce(+, (Pg_c[c,s,t,i[1]] for i in indexin(b,bus_data_gsheet) if ~isnothing(indexin(b,bus_data_gsheet)[1])); init=0)
# +
# reduce(+, (prof_PRES[s,t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
# +
# reduce(+, (pen_lsh_c[c,s,t,i[1]] for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
# -
# reduce(+, (pen_ws_c[c,s,t,i[1]] for i in indexin(b,RES_bus) if ~isnothing(indexin(b,RES_bus)[1])); init=0)
# -
# reduce(+, (p_ch_c[c,s,t,i[1]] for i in indexin(b,nd_Str_active)  if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)
# +
# reduce(+, (p_dis_c[c,s,t,i[1]] for i in indexin(b,nd_Str_active)  if ~isnothing(indexin(b,nd_Str_active)[1])); init=0)
#
# # +slack_pb_p_c[c,s,t,b]-slack_pb_n_c[c,s,t,b]
#
#  ==reduce(+, (pinj_dict_c[[c,s,t,b,j]] for j in node_data_contin[c][b].node_cnode_c if ~isempty(node_data_contin[c][b].node_num_c)); init=0)
#
#  +
#  reduce(+, (pinj_dict_c[[c,s,t,b,j]] for j in node_data_trans[b,1].node_cnode if ~isempty(node_data_trans[b,1].node_num)); init=0)
#  +
#  reduce(+, (prof_ploads[i[1],t]  for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
#  +
#  reduce(+, (p_fl_inc_c[c,s,t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
#  -
#  reduce(+, (p_fl_dec_c[c,s,t,i[1]] for i in indexin(b,nd_fl) if ~isnothing(indexin(b,nd_fl)[1])); init=0)
#
#
#      )
#
#
#           @constraint(model_name, reactive_power_balance_contin[c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus],
#
#            reduce(+, (Qg_c[c,s,t,i[1]] for i in indexin(b,bus_data_gsheet) if ~isnothing(indexin(b,bus_data_gsheet)[1])); init=0)
#
#             # ==reduce(+, (qinj_dict_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]] for j in 1:size(node_data_contin[c][b].node_num_c,1) if ~isempty(node_data_contin[c][b].node_num_c)); init=0)
#
#      # +slack_rb_p_c[c,s,t,b]-slack_rb_n_c[c,s,t,b]
#
#
#             ==reduce(+, (qinj_dict_c[[c,s,t,b,j]] for j in node_data_contin[c][b].node_cnode_c if ~isempty(node_data_contin[c][b].node_num_c)); init=0)
#             +
#             # reduce(+, (qinj_dict_c[[c,s,t,b,node_data_trans[b,1].node_cnode[j]]] for j in 1:size(node_data_trans[b,1].node_num,1) if ~isempty(node_data_trans[b,1].node_num)); init=0)
#             reduce(+, (qinj_dict_c[[c,s,t,b,j]] for j in node_data_trans[b,1].node_cnode if ~isempty(node_data_trans[b,1].node_num)); init=0)
#             # sum(qinj_dict_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]] for j in 1:size(node_data_contin[c][b].node_num_c,1) )
#             +
#             reduce(+, (prof_qloads[i[1],t]  for i in indexin(b,bus_data_lsheet) if ~isnothing(indexin(b,bus_data_lsheet)[1])); init=0)
#
#             -
#             reduce(+, (nw_shunts[i[1]].shunt_bsh0  for i in indexin(b,rdata_shunts[:,1]) if ~isnothing(indexin(b,rdata_shunts[:,1])[1])); init=0)
#
#                 )


     return active_power_balance_contin,reactive_power_balance_contin
     end


    function line_flow_t_n_full(model_name, included_lines_indicator, violated_lines_indicator)
    lin_slp=tan(deg2rad(30))

    if included_lines_indicator==0 && violated_lines_indicator==0

    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]<=0
    # )
    #
    # line_flow_normal_L2=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]<=0
    # )
    # line_flow_normal_L3=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]>=0
    # )
    # line_flow_normal_L4=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]>=0
    # )


    line_flow_normal_L1=@constraint(model_name, [ t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
    )

    line_flow_normal_L2=@constraint(model_name, [ t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
    )
    line_flow_normal_L3=@constraint(model_name, [ t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
    )
    line_flow_normal_L4=@constraint(model_name, [ t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
    pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
    )

    elseif included_lines_indicator==1 && violated_lines_indicator==0

        line_flow_normal_L1=@constraint(model_name, [t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]])],
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
        )

        line_flow_normal_L2=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]])],
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
        )
        line_flow_normal_L3=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]])],
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
        )
        line_flow_normal_L4=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]])],
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
        )
    elseif included_lines_indicator==1 && violated_lines_indicator==1
        line_flow_normal_L1=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
        )

        line_flow_normal_L2=@constraint(model_name, [t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L2=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
        )
        line_flow_normal_L3=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L3=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
        )
        # line_flow_normal_L4=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        line_flow_normal_L4=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && ~haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]>=0
        )

        line_flow_normal_L5=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L5=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]*(1-br_viol_perc_dic[[t,b,node_data[b].node_cnode[j]]])<=0
        )

        line_flow_normal_L6=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L6=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]*(1-br_viol_perc_dic[[t,b,node_data[b].node_cnode[j]]])<=0
        )
        line_flow_normal_L7=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L7=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
#
        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]*(1-br_viol_perc_dic[[t,b,node_data[b].node_cnode[j]]])>=0
        )
        line_flow_normal_L8=@constraint(model_name, [ t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) && haskey(first_pf_norm_br_dic,[t,b,node_data[b].node_cnode[j]]) && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],
        # line_flow_normal_L8=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num)  && haskey(br_viol_nr_dic,[t,b,node_data[b].node_cnode[j]])],

        pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]*(1-br_viol_perc_dic[[t,b,node_data[b].node_cnode[j]]])>=0
        )

    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1); ~isempty(node_data[b].node_num)],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
    # )
    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1); ~isempty(node_data[b].node_num)],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]<=0
    # )
    #
    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1); ~isempty(node_data[b].node_num)],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]<=0
    # )
    #
    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1); ~isempty(node_data[b].node_num)],
    # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]<=0
    # )



    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ~isempty(node_data[b].node_num)],
    # pinj_dict[[t,b,j]]-lin_slp*qinj_dict[[t,b,j]]-node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
    # )
    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ~isempty(node_data[b].node_num)],
    # pinj_dict[[t,b,j]]+lin_slp*qinj_dict[[t,b,j]]+node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
    # )
    # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ~isempty(node_data[b].node_num)],
    # pinj_dict[[t,b,j]]-lin_slp*qinj_dict[[t,b,j]]-node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
    # )
    end
    # return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4

        end



        function line_flow_t_c_full(model_name, included_lines_indicator, violated_lines_indicator)
        lin_slp=tan(deg2rad(30))


        if included_lines_indicator==0 && violated_lines_indicator==0

        # line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        # pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]-slack_n_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]<=0
        # )
        #
        # line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        # pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]-slack_n_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]<=0
        # )
        #
        # line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        # pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]-slack_n_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]>=0
        # )
        #
        # line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        # pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]-slack_n_c[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]>=0
        # )


        line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
        )

        line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
        )

        line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
        )

        line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
        )
        return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4
        elseif included_lines_indicator==1 && violated_lines_indicator==0

        line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) ],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
        )

        line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) ],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
        )

        line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) ],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
        )

        line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) ],
        pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
        )
        elseif included_lines_indicator==1 && violated_lines_indicator==1
            line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
            )

            line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]<=0
            )

            line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
            )

            line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]>=0
            )

            line_flow_contin_L5=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L5=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]*(1-br_viol_perc_c_dic[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]])<=0
            )


            line_flow_contin_L6=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L6=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-node_data_contin[c][b].node_smax_c[j]*(1-br_viol_perc_c_dic[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]])<=0
            )

            line_flow_contin_L7=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L7=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]*(1-br_viol_perc_c_dic[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]])>=0
            )

            line_flow_contin_L8=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c) && haskey(first_pf_contin_br_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]) && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],
            # line_flow_contin_L8=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]])],

            pinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]-lin_slp*qinj_dict_l_c[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]]+node_data_contin[c][b].node_smax_c[j]*(1-br_viol_perc_c_dic[[c,s,t,b,node_data_contin[c][b].node_cnode_c[j]]])>=0
            )




        end

        # return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4
        end

            function line_flow_t_n_half(model_name, included_lines_indicator, violated_lines_indicator)
            lin_slp=tan(deg2rad(30))

            if included_lines_indicator==0 && violated_lines_indicator==0

            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
            # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]<=0
            # )
            #
            # line_flow_normal_L2=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
            # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]<=0
            # )
            # line_flow_normal_L3=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
            # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]>=0
            # )
            # line_flow_normal_L4=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data[b].node_num,1);~isempty(node_data[b].node_num) ],
            # pinj_dict_l[[t,b,node_data[b].node_cnode[j]]]-lin_slp*qinj_dict_l[[t,b,node_data[b].node_cnode[j]]]+node_data[b,1].node_smax[j,1]+slack_p[t,b,node_data[b].node_cnode[j]]-slack_n[t,b,node_data[b].node_cnode[j]]>=0
            # )


            @constraint(model_name, line_flow_normal_L1[ t in 1:nTP, l in 1:nLines ],
            pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
            )

            @constraint(model_name, line_flow_normal_L2[ t in 1:nTP, l in 1:nLines ],
            pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
            )
            @constraint(model_name, line_flow_normal_L3[ t in 1:nTP, l in 1:nLines ],
            pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
            )
            @constraint(model_name, line_flow_normal_L4[ t in 1:nTP, l in 1:nLines ],
            pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
            )
            line_flow_normal_L5=nothing
            line_flow_normal_L6=nothing
            line_flow_normal_L7=nothing
            line_flow_normal_L8=nothing
                     return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4,line_flow_normal_L5,line_flow_normal_L6,line_flow_normal_L7,line_flow_normal_L8
            elseif included_lines_indicator==1 && violated_lines_indicator==0

                @constraint(model_name, line_flow_normal_L1[t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]])],
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
                )

                @constraint(model_name, line_flow_normal_L2[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]])],
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
                )
                @constraint(model_name, line_flow_normal_L3[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]])],
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
                )
                @constraint(model_name, line_flow_normal_L4[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]])],
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
                )
                line_flow_normal_L5=nothing
                line_flow_normal_L6=nothing
                line_flow_normal_L7=nothing
                line_flow_normal_L8=nothing
                return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4,line_flow_normal_L5,line_flow_normal_L6,line_flow_normal_L7,line_flow_normal_L8
            elseif included_lines_indicator==1 && violated_lines_indicator==1
                @constraint(model_name, line_flow_normal_L1[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
                )

                @constraint(model_name, line_flow_normal_L2[t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L2=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
                )
                @constraint(model_name, line_flow_normal_L3[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L3=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
                )
                # line_flow_normal_L4=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                @constraint(model_name, line_flow_normal_L4[ t in 1:nTP,  l in 1:nLines;haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
                )

                @constraint(model_name, line_flow_normal_L5[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L5=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])<=0
                )

                @constraint(model_name, line_flow_normal_L6[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L6=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])<=0
                )
                @constraint(model_name, line_flow_normal_L7[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L7=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
        #
                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])>=0
                )
                @constraint(model_name, line_flow_normal_L8[ t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
                # line_flow_normal_L8=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

                pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])>=0
                )
             return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4,line_flow_normal_L5,line_flow_normal_L6,line_flow_normal_L7,line_flow_normal_L8

         elseif included_lines_indicator==0 && violated_lines_indicator==1
             @constraint(model_name, line_flow_normal_L1[ t in 1:nTP,  l in 1:nLines],
             # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
             )

             @constraint(model_name, line_flow_normal_L2[t in 1:nTP,  l in 1:nLines],
             # line_flow_normal_L2=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
             )
             @constraint(model_name, line_flow_normal_L3[ t in 1:nTP,  l in 1:nLines],
             # line_flow_normal_L3=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
             )
             # line_flow_normal_L4=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines; haskey(first_pf_norm_br_dic,[t,idx_from_line[l],idx_to_line[l]]) && ~haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             @constraint(model_name, line_flow_normal_L4[ t in 1:nTP,  l in 1:nLines],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A>=0
             )

             @constraint(model_name, line_flow_normal_L5[ t in 1:nTP,  l in 1:nLines;  haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             # line_flow_normal_L5=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])<=0
             )

             @constraint(model_name, line_flow_normal_L6[ t in 1:nTP,  l in 1:nLines;  haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             # line_flow_normal_L6=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])<=0
             )
             @constraint(model_name, line_flow_normal_L7[ t in 1:nTP,  l in 1:nLines;  haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             # line_flow_normal_L7=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
     #
             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])>=0
             )
             @constraint(model_name, line_flow_normal_L8[ t in 1:nTP,  l in 1:nLines; haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],
             # line_flow_normal_L8=@constraint(model_name, [s in 1:nSc, t in 1:nTP,  l in 1:nLines;  && haskey(br_viol_nr_dic,[t,idx_from_line[l],idx_to_line[l]])],

             pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A*(1-br_viol_perc_dic[[t,idx_from_line[l],idx_to_line[l]]])>=0
             )
          return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4,line_flow_normal_L5,line_flow_normal_L6,line_flow_normal_L7,line_flow_normal_L8
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, l in 1:nLines; ],
            # pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
            # )
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, l in 1:nLines; ],
            # pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-nw_lines[l].line_Smax_A<=0
            # )
            #
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, l in 1:nLines; ],
            # pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A<=0
            # )
            #
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, l in 1:nLines; ],
            # pinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]-lin_slp*qinj_dict_l[[t,idx_from_line[l],idx_to_line[l]]]+nw_lines[l].line_Smax_A<=0
            # )



            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ],
            # pinj_dict[[t,b,j]]-lin_slp*qinj_dict[[t,b,j]]-node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
            # )
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ],
            # pinj_dict[[t,b,j]]+lin_slp*qinj_dict[[t,b,j]]+node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
            # )
            # line_flow_normal_L1=@constraint(model_name, [s in 1:nSc, t in 1:nTP, b in 1:nBus, j in node_data[b].node_cnode; ~isempty(node_data[b].node_num)],
            # pinj_dict[[t,b,j]]-lin_slp*qinj_dict[[t,b,j]]-node_data[b,1].node_smax[indexin(j, node_data[b].node_cnode)[1],1]<=0
            # )
            end
            # return line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4

                end



                function line_flow_t_c_half(model_name, included_lines_indicator, violated_lines_indicator)
                lin_slp=tan(deg2rad(30))


                if included_lines_indicator==0 && violated_lines_indicator==0

                # line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
                # pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]-slack_n_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]<=0
                # )
                #
                # line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
                # pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]-slack_n_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]<=0
                # )
                #
                # line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
                # pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]-slack_n_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]>=0
                # )
                #
                # line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus, j in 1:size(node_data_contin[c][b].node_cnode_c,1); ~isempty(node_data_contin[c][b].node_num_c)],
                # pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+node_data_contin[c][b].node_smax_c[j]+slack_p_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]-slack_n_c[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]>=0
                # )


                @constraint(model_name, line_flow_contin_L1[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c])],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                )

                @constraint(model_name, line_flow_contin_L2[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c])],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                )

                @constraint(model_name, line_flow_contin_L3[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c])],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                )


                @constraint(model_name, line_flow_contin_L4[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                )
                line_flow_contin_L5=nothing
                line_flow_contin_L6=nothing
                line_flow_contin_L7=nothing
                line_flow_contin_L8=nothing

                return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4,line_flow_contin_L5,line_flow_contin_L6,line_flow_contin_L7,line_flow_contin_L8
                elseif included_lines_indicator==1 && violated_lines_indicator==0

                @constraint(model_name, line_flow_contin_L1[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) ],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                )

                @constraint(model_name, line_flow_contin_L2[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) ],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                )

                @constraint(model_name, line_flow_contin_L3[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) ],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                )

                @constraint(model_name, line_flow_contin_L4[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) ],
                pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                )
                line_flow_contin_L5=nothing
                line_flow_contin_L6=nothing
                line_flow_contin_L7=nothing
                line_flow_contin_L8=nothing

                return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4,line_flow_contin_L5,line_flow_contin_L6,line_flow_contin_L7,line_flow_contin_L8
                elseif included_lines_indicator==1 && violated_lines_indicator==1
                    @constraint(model_name, line_flow_contin_L1[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                    )

                    @constraint(model_name, line_flow_contin_L2[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                    )

                    @constraint(model_name, line_flow_contin_L3[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                    )

                    @constraint(model_name, line_flow_contin_L4[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                    )

                    @constraint(model_name, line_flow_contin_L5[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L5=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])<=0
                    )


                    @constraint(model_name, line_flow_contin_L6[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L6=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])<=0
                    )

                    @constraint(model_name, line_flow_contin_L7[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L7=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])>=0
                    )

                    @constraint(model_name, line_flow_contin_L8[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);  haskey(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]) && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L8=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])>=0
                    )
                    return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4,line_flow_contin_L5,line_flow_contin_L6,line_flow_contin_L7,line_flow_contin_L8


                elseif included_lines_indicator==0 && violated_lines_indicator==1
                    @constraint(model_name, line_flow_contin_L1[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
                    # line_flow_contin_L1=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                    )

                    @constraint(model_name, line_flow_contin_L2[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c])],
                    # line_flow_contin_L2=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]<=0
                    )

                    @constraint(model_name, line_flow_contin_L3[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c])],
                    # line_flow_contin_L3=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                    )

                    @constraint(model_name, line_flow_contin_L4[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
                    # line_flow_contin_L4=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && ~haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]>=0
                    )

                    @constraint(model_name, line_flow_contin_L5[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);   haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L5=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])<=0
                    )


                    @constraint(model_name, line_flow_contin_L6[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);   haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L6=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])<=0
                    )

                    @constraint(model_name, line_flow_contin_L7[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);   haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L7=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])>=0
                    )

                    @constraint(model_name, line_flow_contin_L8[c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]);   haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],
                    # line_flow_contin_L8=@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP,  l in 1:length(idx_from_line_c[c]); ~isempty(node_data_contin[c][b].node_num_c)  && haskey(br_viol_c_dic,[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]])],

                    pinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]-lin_slp*qinj_dict_l_c[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]+line_smax_c[c][l]*(1-br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]])>=0
                    )
                    return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4,line_flow_contin_L5,line_flow_contin_L6,line_flow_contin_L7,line_flow_contin_L8




                end

                # return  line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4
                end

function objective_t_SCOPF(model_name)


            cost_gen=@expression(model_name,
                        sum(
                                # Pg[t,i]*Pg[t,i]*cost_a_gen[i]*(sbase^2)
                                # +
                                Pg[t,i]*cost_b_gen[i]*sbase
                                # +
                                # cost_c_gen[i]
                                for t in 1:nTP,i in 1:nGens )
        )
# penalty_cost=1e4
        cost_pen_lsh_aux=@expression(model_name,
                            [i=1:nBus ; ~isnothing(indexin(i,bus_data_lsheet)[1]) ],
                            sum(penalty_cost*(pen_lsh[t,indexin(i,bus_data_lsheet)]) for t in 1:nTP)
                                     )
                       cost_pen_lsh=@expression(model_name,sum(cost_pen_lsh_aux))
        # # -----Generation curtailment----
        cost_pen_ws_aux=@expression(model_name,
                            [i=1:nBus; ~isnothing(indexin(i,RES_bus)[1]) ],
                            sum(penalty_cost*(pen_ws[t,indexin(i,RES_bus)]) for t in 1:nTP)
                                     )
                        cost_pen_ws=@expression(model_name,if !isempty(RES_bus) sum(cost_pen_ws_aux) end)
        #
        # # -------------penalty cost post contingency states------------
        # # --------loadshedding cost-----
        #
        cost_pen_lsh_aux_c=@expression(model_name,
                           [i=1:nBus ; ~isnothing(indexin(i,bus_data_lsheet)[1]) ],
                           sum(penalty_cost*(pen_lsh_c[c,s,t,indexin(i,bus_data_lsheet)[1]]) for c in 1:nCont,s in 1:nSc,t in 1:nTP)
                                     )
        cost_pen_lsh_c=@expression(model_name,sum(cost_pen_lsh_aux_c))

        #------penalties on active power balance ----------
        # cost_penalty_aux_pb=@expression(acopf,
        #                        [i=1:nBus ],
        #                            sum(penalty_cost*(slack_pb_p[s,t,i]+slack_pb_n[s,t,i]) for s in 1:nSc,t in 1:nTP)
        #                                                          )
        #                                           cost_pen_pb=@expression(acopf,sum(cost_penalty_aux_pb))

        # cost_penalty_aux_pb_c=@expression(model_name,     [c=1:nCont,i=1:nBus],
        #                          sum(5*penalty_cost*(slack_pb_p_c[c,s,t,i]+slack_pb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
        #                          # sum(penalty_cost*(slack_pb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
        #              )
        # cost_pen_pb_c=@expression(model_name,sum(cost_penalty_aux_pb_c))
        #------penalties on reactive power balance ----------
        # cost_penalty_aux_rb=@expression(acopf,
        #                        [i=1:nBus ],
        #                            sum(penalty_cost*(slack_rb_p[s,t,i]+slack_rb_n[s,t,i]) for s in 1:nSc,t in 1:nTP)
        #                                                          )
        #                                           cost_pen_rb=@expression(acopf,sum(cost_penalty_aux_rb))
        # #
        # cost_penalty_aux_rb_c=@expression(acopf,     [c=1:nCont,i=1:nBus],
        #                          sum(penalty_cost*(slack_rb_p_c[c,s,t,i]+slack_rb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
        #              )
        # cost_pen_rb_c=@expression(acopf,sum(cost_penalty_aux_rb_c))

        # cost_penalty=@expression(acopf,
        #                                  [i=1:nBus ; ~isempty(node_data[i,1].node_num)],
        #                                  sum(penalty_cost*(slack[s,t,i,node_data[i,1].node_cnode[j,1][1]]) for s in 1:nSc,t in 1:nTP, j in 1:size(node_data[i,1].node_num,1))
        #                                            )
        #                             cost_pen_c=@expression(acopf,sum(cost_penalty))
        # # ------ Generation curtailment----
        cost_pen_ws_aux_c=@expression(model_name,
                           [i=1:nBus; ~isnothing(indexin(i,RES_bus)[1]) ],
                           sum(penalty_cost*(pen_ws_c[c,s,t,indexin(i,RES_bus)[1]]) for c in 1:nCont, s in 1:nSc,t in 1:nTP)
                                     )
                      cost_pen_ws_c=@expression(model_name,if !isempty(RES_bus) sum(cost_pen_ws_aux_c) end)
        #
        #
        # # --------Flexible load cost normal state-------
        cost_fl_aux=@expression(model_name,
                           [i=1:nBus, idx_flex=indexin(i,nd_fl); ~isnothing(indexin(i,nd_fl)[1]) ],
                           sum(
                           cost_flex_load[idx_flex]*sbase
                           *
                           (p_fl_inc[t,indexin(i,nd_fl)]+p_fl_dec[t,indexin(i,nd_fl)]) for t in 1:nTP)
                           )
                    cost_fl=@expression(model_name,if nFl!=0 sum(cost_fl_aux) end)
        # # --------Flexible load cost post contingency state-------
        cost_fl_aux_c=@expression(model_name,
                           [c=1:nCont, i=1:nBus, idx_flex=indexin(i,nd_fl); ~isnothing(indexin(i,nd_fl)[1]) ],
                           sum(
                           cost_flex_load[idx_flex]*sbase
                           *
                           (p_fl_inc_c[c,s,t,indexin(i,nd_fl)]+p_fl_dec_c[c,s,t,indexin(i,nd_fl)]) for s in 1:nSc,t in 1:nTP)
                                  )
                      cost_fl_c  =@expression(model_name,if nFl!=0 sum(cost_fl_aux_c) end)
        #
        # # ----------storage cost normal state-------
        cost_str_aux=@expression(model_name,
                               [i=1:nBus, idx_str=indexin(i,nd_Str_active); ~isnothing(indexin(i,nd_Str_active)[1]) ],
                               sum(
                               cost_b_str[idx_str]*(sbase)*( p_ch[t,idx_str]+p_dis[t,idx_str])
                               for t in 1:nTP)
                                  )
                     cost_str  =@expression(model_name,if nStr_active!=0 sum(cost_str_aux) end )
        # # ----------storage cost post contingency state-----
        cost_str_aux_c=@expression(model_name,
                               [c=1:nCont,i=1:nBus, idx_str=indexin(i,nd_Str_active); ~isnothing(indexin(i,nd_Str_active)[1]) ],
                               sum(
                               cost_b_str[idx_str]*(sbase)*( p_ch_c[c,s,t,idx_str]+p_dis_c[c,s,t,idx_str])
                               for s in 1:nSc,t in 1:nTP)
                                  )
                     cost_str_c  =@expression(model_name,if nStr_active!=0 sum(cost_str_aux_c) end)
        #

        total_cost=@expression(model_name,
                   # (
                   0.95*
                   (cost_gen
                   +sum(cost_pen_lsh)
                   # +cost_pen_pb
                   # +cost_pen_rb
                   # +cost_pen_c
                   +sum((if !isnothing(cost_fl) cost_fl else 0 end))
                   +sum((if !isnothing(cost_str) cost_str else 0 end))
                   +sum((if !isnothing(cost_pen_ws) cost_pen_ws else 0 end))
                   # +sum(cost_pen_ws)
                   )
                   +
                   0.05*(1/nSc)*(
                   sum(cost_pen_lsh_c)
                   # +sum(cost_pen_pb_c)
                   # +cost_pen_rb_c
                   # +sum(cost_pen_ws_c)
                   +sum((if !isnothing(cost_pen_ws_c) cost_pen_ws_c else 0 end))
                   +sum((if !isnothing(cost_fl_c) cost_fl_c else 0 end))
                   +sum((if !isnothing(cost_str_c) cost_str_c else 0 end))
                   # )
                     )
                       )
        @objective(model_name,Min,total_cost)
        return total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str,cost_pen_ws,cost_pen_lsh_c,cost_pen_ws_c,cost_fl_c,cost_str_c
        # end
        end
        function objective_t_OPF(model_name)


                    cost_gen=@expression(model_name,
                                sum(
                                        # Pg[t,i]*Pg[t,i]*cost_a_gen[i]*(sbase^2)
                                        # +
                                        Pg[t,i]*cost_b_gen[i]*sbase
                                        # +
                                        # cost_c_gen[i]
                                        for t in 1:nTP,i in 1:nGens )
                )
        # penalty_cost=1e4
                cost_pen_lsh_aux=@expression(model_name,
                                    [i=1:nBus ; ~isnothing(indexin(i,bus_data_lsheet)[1]) ],
                                    sum(penalty_cost*(pen_lsh[t,indexin(i,bus_data_lsheet)]) for t in 1:nTP)
                                             )
                               cost_pen_lsh=@expression(model_name,sum(cost_pen_lsh_aux))
                # # -----Generation curtailment----
                cost_pen_ws_aux=@expression(model_name,
                                    [i=1:nBus; ~isnothing(indexin(i,RES_bus)[1]) ],
                                    sum(penalty_cost*(pen_ws[t,indexin(i,RES_bus)]) for t in 1:nTP)
                                             )
                               cost_pen_ws=@expression(model_name,if !isempty(RES_bus) sum(cost_pen_ws_aux) end)
                #
                # # -------------penalty cost post contingency states------------
                # # --------loadshedding cost-----
                #
                # cost_pen_lsh_aux_c=@expression(model_name,
                #                    [i=1:nBus ; ~isnothing(indexin(i,bus_data_lsheet)[1]) ],
                #                    sum(penalty_cost*(pen_lsh_c[c,s,t,indexin(i,bus_data_lsheet)]) for c in 1:nCont,s in 1:nSc,t in 1:nTP)
                #                              )
                # cost_pen_lsh_c=@expression(model_name,sum(cost_pen_lsh_aux_c))

                #------penalties on active power balance ----------
                # cost_penalty_aux_pb=@expression(acopf,
                #                        [i=1:nBus ],
                #                            sum(penalty_cost*(slack_pb_p[s,t,i]+slack_pb_n[s,t,i]) for s in 1:nSc,t in 1:nTP)
                #                                                          )
                #                                           cost_pen_pb=@expression(acopf,sum(cost_penalty_aux_pb))

                # cost_penalty_aux_pb_c=@expression(acopf,     [c=1:nCont,i=1:nBus],
                #                          # sum(penalty_cost*(slack_pb_p_c[c,s,t,i]+slack_pb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
                #                          sum(penalty_cost*(slack_pb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
                #              )
                # cost_pen_pb_c=@expression(acopf,sum(cost_penalty_aux_pb_c))
                #------penalties on reactive power balance ----------
                # cost_penalty_aux_rb=@expression(acopf,
                #                        [i=1:nBus ],
                #                            sum(penalty_cost*(slack_rb_p[s,t,i]+slack_rb_n[s,t,i]) for s in 1:nSc,t in 1:nTP)
                #                                                          )
                #                                           cost_pen_rb=@expression(acopf,sum(cost_penalty_aux_rb))
                # #
                # cost_penalty_aux_rb_c=@expression(acopf,     [c=1:nCont,i=1:nBus],
                #                          sum(penalty_cost*(slack_rb_p_c[c,s,t,i]+slack_rb_n_c[c,s,t,i]) for s in 1:nSc,t in 1:nTP)
                #              )
                # cost_pen_rb_c=@expression(acopf,sum(cost_penalty_aux_rb_c))

                # cost_penalty=@expression(acopf,
                #                                  [i=1:nBus ; ~isempty(node_data[i,1].node_num)],
                #                                  sum(penalty_cost*(slack[s,t,i,node_data[i,1].node_cnode[j,1][1]]) for s in 1:nSc,t in 1:nTP, j in 1:size(node_data[i,1].node_num,1))
                #                                            )
                #                             cost_pen_c=@expression(acopf,sum(cost_penalty))
                # # ------ Generation curtailment----
                # cost_pen_ws_aux_c=@expression(model_name,
                #                    [i=1:nBus; ~isnothing(indexin(i,RES_bus)) ],
                #                    sum(penalty_cost*(pen_ws_c[c,s,t,indexin(i,RES_bus)]) for c in 1:nCont, s in 1:nSc,t in 1:nTP)
                #                              )
                #               cost_pen_ws_c=@expression(model_name,sum(cost_pen_ws_aux_c))
                #
                #
                # # --------Flexible load cost normal state-------
                cost_fl_aux=@expression(model_name,
                                   [i=1:nBus, idx_flex=indexin(i,nd_fl); ~isnothing(indexin(i,nd_fl)[1]) ],
                                   sum(
                                   cost_flex_load[idx_flex]*sbase
                                   *
                                   (p_fl_inc[t,indexin(i,nd_fl)]+p_fl_dec[t,indexin(i,nd_fl)]) for t in 1:nTP)
                                   )
                            cost_fl=@expression(model_name,if nFl!=0 sum(cost_fl_aux) end)
                # # --------Flexible load cost post contingency state-------
                # cost_fl_aux_c=@expression(model_name,
                #                    [c=1:nCont, i=1:nBus, idx_flex=indexin(i,nd_fl); ~isnothing(indexin(i,nd_fl)) ],
                #                    sum(
                #                    cost_flex_load[idx_flex]*sbase
                #                    *
                #                    (p_fl_inc_c[c,s,t,indexin(i,nd_fl)]+p_fl_dec_c[c,s,t,indexin(i,nd_fl)]) for s in 1:nSc,t in 1:nTP)
                #                           )
                #              cost_fl_c  =@expression(model_name,sum(cost_fl_aux_c))
                #
                # # ----------storage cost normal state-------
                cost_str_aux=@expression(model_name,
                                       [i=1:nBus, idx_str=indexin(i,nd_Str_active); ~isnothing(indexin(i,nd_Str_active)[1]) ],
                                       sum(
                                       cost_b_str[idx_str]*(sbase)*( p_ch[t,idx_str]+p_dis[t,idx_str])
                                       for t in 1:nTP)
                                          )
                              cost_str  =@expression(model_name,if nStr_active!=0 sum(cost_str_aux) end )
                # # ----------storage cost post contingency state-----
                # cost_str_aux_c=@expression(model_name,
                #                        [c=1:nCont,i=1:nBus, idx_str=indexin(i,nd_Str_active); ~isnothing(indexin(i,nd_Str_active)) ],
                #                        sum(
                #                        cost_b_str[idx_str]*(sbase)*( p_ch_c[c,s,t,idx_str]+p_dis_c[c,s,t,idx_str])
                #                        for s in 1:nSc,t in 1:nTP)
                #                           )
                #              cost_str_c  =@expression(model_name,sum(cost_str_aux_c))
                #

                total_cost=@expression(model_name,
                           # (
                           0.95*
                           (cost_gen
                           +sum(cost_pen_lsh)
                           # +cost_pen_pb
                           # +cost_pen_rb
                           # +cost_pen_c
                           +sum((if !isnothing(cost_fl) cost_fl else 0 end))
                           +sum((if !isnothing(cost_str) cost_str else 0 end))
                           +sum((if !isnothing(cost_pen_ws) cost_pen_ws else 0 end))
                           # +sum(cost_pen_ws)
                           )
                           # +
                           # 0.05*(
                           # sum(cost_pen_lsh_c)
                           # # +cost_pen_pb_c
                           # # +cost_pen_rb_c
                           # +sum(cost_pen_ws_c)
                           # +sum(cost_fl_c)
                           # +sum(cost_str_c)
                           # # )
                           #   )
                               )
                @objective(model_name,Min,total_cost)
                return total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str,cost_pen_ws#,cost_pen_lsh_c,cost_pen_ws_c,cost_fl_c,cost_str_c
                # end
                end
function coupling_constraint_t(model_name)
ramp_rate=2
@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nGens],-ramp_rate<=Pg_c[c,s,t,i]-Pg[t,i])
@constraint(model_name, [c=1:nCont,s=1:nSc,t=1:nTP,i=1:nGens],Pg_c[c,s,t,i]-Pg[t,i]<=ramp_rate)

end
function loss_gr_zero_n(loss_indicator,ploss_dic,ploss_trans_dic,v_sq)
    if loss_indicator==1
@constraint(model_name, loss_gr_zero_n_from[s in 1:nSc, t in 1:nTP, l in 1:nLines],
ploss_dic[[s,t,idx_from_line[l],idx_to_line[l]]]>=0)

@constraint(model_name, loss_gr_zero_n_to[s in 1:nSc, t in 1:nTP, l in 1:nLines],
ploss_dic[[s,t,idx_to_line[l],idx_from_line[l]]]>=0)

@constraint(model_name, loss_gr_zero_n_from_trans[s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
ploss_trans_dic[[s,t,nw_trans[l].trans_bus_from,nw_trans[l].trans_bus_to]]>=0)

@constraint(model_name, loss_gr_zero_n_to_trans[s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
ploss_trans_dic[[s,t,nw_trans[l].trans_bus_to,nw_trans[l].trans_bus_from]]>=0)
end
end

function loss_gr_zero_c(loss_indicator)
        if loss_indicator==1
    @constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
    ploss_c_dict[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]>=0)

    @constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
    ploss_c_dict[[c,s,t,idx_to_line_c[c][l],idx_from_line_c[c][l]]]>=0)

    @constraint(model_name, loss_gr_zero_c_from_trans[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
    ploss_trans_dic_c[[c,s,t,nw_trans[l].trans_bus_from,nw_trans[l].trans_bus_to]]>=0)

    @constraint(model_name, loss_gr_zero_c_to_trans[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
    ploss_trans_dic_c[[c,s,t,nw_trans[l].trans_bus_to,nw_trans[l].trans_bus_from]]>=0)
end
end

function violated_voltage(indicator_iter,violated_voltage_normal_dic,violated_voltage_contin_dic)
    relaxation_f=0.001
 if indicator_iter==3
     violated_voltage_normal_dic=Dict{Array{Int64,1},Int64}()
     violated_voltage_contin_dic=Dict{Array{Int64,1},Int64}()


violated_voltage_normal=[]
for  s in 1, t in 1:nTP, b in 1:nBus
violated_voltage_nr=findall(x->x>nw_buses[b].bus_vmax+relaxation_f || x<nw_buses[b].bus_vmin-relaxation_f, pf_result_perscen_normal[s][t][1][b])
if ~isempty(violated_voltage_nr)
    push!(violated_voltage_normal,[t,b])
end
end



 for i in eachindex(violated_voltage_normal)
  push!(violated_voltage_normal_dic, violated_voltage_normal[i] => 1)
end


violated_voltage_contin=[]
# violated_voltage_contin_value=[]
for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
voltage_violation_c=findall(x->x>(nw_buses[b].bus_vmax+v_relax_factor_max)+relaxation_f || x<(nw_buses[b].bus_vmin-v_relax_factor_min)-relaxation_f, pf_per_dimension[c,s][t][1][b])
if ~isempty(voltage_violation_c)
    push!(violated_voltage_contin,[c,s,t,b])
    # push!(violated_voltage_contin_value,voltage_violation_c)
end
end



 for i in eachindex(violated_voltage_contin)
  push!(violated_voltage_contin_dic, violated_voltage_contin[i] => 1)
end
return violated_voltage_normal_dic,violated_voltage_contin_dic
elseif indicator_iter==4

    violated_voltage_normal=[]
    for  s in 1, t in 1:nTP, b in 1:nBus
    violated_voltage_nr=findall(x->x>nw_buses[b].bus_vmax+relaxation_f || x<nw_buses[b].bus_vmin-relaxation_f, pf_result_perscen_normal[s][t][1][b])
    if ~isempty(violated_voltage_nr)
        push!(violated_voltage_normal,[t,b])
    end
    end



     for i in eachindex(violated_voltage_normal)
      push!(violated_voltage_normal_dic, violated_voltage_normal[i] => 1)
    end


    violated_voltage_contin=[]
    # violated_voltage_contin_value=[]
    for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
    voltage_violation_c=findall(x->x>(nw_buses[b].bus_vmax+v_relax_factor_max)+relaxation_f || x<(nw_buses[b].bus_vmin-v_relax_factor_min)-relaxation_f, pf_per_dimension[c,s][t][1][b])
    if ~isempty(voltage_violation_c)
        push!(violated_voltage_contin,[c,s,t,b])
        # push!(violated_voltage_contin_value,voltage_violation_c)
    end
    end



     for i in eachindex(violated_voltage_contin)
      push!(violated_voltage_contin_dic, violated_voltage_contin[i] => 1)
    end

return violated_voltage_normal_dic,violated_voltage_contin_dic
end

end


function highly_loaded_lines(indicator_iter,first_pf_norm_br_dic,first_pf_contin_br_dic)
    # branch_flow_check[10,24][1] returns the Sij for all lines and branch_flow_check[10,24][2] returns the violated lines index and branch_flow_check[10,24][3] returns the violated percentage and branch_flow_check[10,24][4] counts the lines loaded over than 70%
     if indicator_iter==3
    first_pf_norm_br_dic=Dict{Array{Int64,1},Int64}()
# first_pf_norm_br=[]
for  t in 1:nTP
    if ~isempty(branch_flow_check[t][4]) # # branch_flow_check[10,24][1]
        for j in branch_flow_check[t][4][1]
            push!(first_pf_norm_br_dic,[t,idx_from_line[j],idx_to_line[j]] => 1)
            push!(first_pf_norm_br_dic,[t,idx_to_line[j],idx_from_line[j]] => 1)
        end
    end
end

# first_pf_norm_br_dic=Dict( first_pf_norm_br[i] => 1 for i in eachindex(first_pf_norm_br) )

first_pf_contin_br_dic=Dict{Array{Int64,1},Int64}()
# first_pf_contin_br=[]
for c in 1:nCont, s in 1:nSc, t in 1:nTP
    if ~isempty(branch_flow_check_c[c,s,t][4]) #branch_flow_check_c[33,10,24][1]
        for j in branch_flow_check_c[c,s,t][4][1]
    push!(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]] => 1)
    push!(first_pf_contin_br_dic,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]] => 1)
end
end
end

# first_pf_contin_br_dic=Dict( first_pf_contin_br[i] => 1 for i in eachindex(first_pf_contin_br) )
return first_pf_norm_br_dic,first_pf_contin_br_dic
elseif indicator_iter==4
    for  t in 1:nTP
        if ~isempty(branch_flow_check[t][4]) # # branch_flow_check[10,24][1]
            for j in branch_flow_check[t][4][1]
                push!(first_pf_norm_br_dic,[t,idx_from_line[j],idx_to_line[j]] => 1)
                push!(first_pf_norm_br_dic,[t,idx_to_line[j],idx_from_line[j]] => 1)
            end
        end
    end

    # first_pf_norm_br_dic=Dict( first_pf_norm_br[i] => 1 for i in eachindex(first_pf_norm_br) )

    # first_pf_contin_br_dic=Dict{Array{Int64,1},Int64}()
    # first_pf_contin_br=[]
    for c in 1:nCont, s in 1:nSc, t in 1:nTP
        if ~isempty(branch_flow_check_c[c,s,t][4]) #branch_flow_check_c[33,10,24][1]
            for j in branch_flow_check_c[c,s,t][4][1]
        push!(first_pf_contin_br_dic,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]] => 1)
        push!(first_pf_contin_br_dic,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]] => 1)
    end
    end
    end

    # first_pf_contin_br_dic=Dict( first_pf_contin_br[i] => 1 for i in eachindex(first_pf_contin_br) )
    return first_pf_norm_br_dic,first_pf_contin_br_dic
end
end

function branch_violation(indicator_iter,br_viol_nr_dic,br_viol_c_dic)
if indicator_iter==3
    br_viol_nr_dic=Dict{Array{Int64,1},Int64}()
    br_viol_c_dic=Dict{Array{Int64,1},Int64}()
br_viol_nr =[]
for  t in 1:nTP
    if ~isempty(branch_flow_check[t][2])
        for j in branch_flow_check[t][2][1]
        push!(br_viol_nr,[t,idx_from_line[j],idx_to_line[j]])
        push!(br_viol_nr,[t,idx_to_line[j],idx_from_line[j]])
    end  end
end



 for i in eachindex(br_viol_nr)
  push!(br_viol_nr_dic, br_viol_nr[i] => 1)
end



br_viol_c=[]
for c in 1:nCont, s in 1:nSc, t in 1:nTP
    if ~isempty(branch_flow_check_c[c,s,t][2])
        for j in branch_flow_check_c[c,s,t][2][1]
        push!(br_viol_c,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]])
        push!(br_viol_c,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]])
    end  end
end

for i in eachindex(br_viol_c)
 push!(br_viol_c_dic, br_viol_c[i] => 1)
end
    return br_viol_nr_dic,br_viol_c_dic
elseif indicator_iter==4
    br_viol_nr =[]
    for  t in 1:nTP
        if ~isempty(branch_flow_check[t][2])
            for j in branch_flow_check[t][2][1]
            push!(br_viol_nr,[t,idx_from_line[j],idx_to_line[j]])
            push!(br_viol_nr,[t,idx_to_line[j],idx_from_line[j]])
        end  end
    end



     for i in eachindex(br_viol_nr)
      push!(br_viol_nr_dic, br_viol_nr[i] => 1)
    end



    br_viol_c=[]
    for c in 1:nCont, s in 1:nSc, t in 1:nTP
        if ~isempty(branch_flow_check_c[c,s,t][2])
            for j in branch_flow_check_c[c,s,t][2][1]
            push!(br_viol_c,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]])
            push!(br_viol_c,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]])
        end  end
    end

    for i in eachindex(br_viol_c)
     push!(br_viol_c_dic, br_viol_c[i] => 1)
    end
    return br_viol_nr_dic,br_viol_c_dic
end
end


function branch_violation_percent(indicator_iter,br_viol_perc_dic,br_viol_perc_c_dic,coeff_nr,coeff_c,coeff_compl,tighten_flag)
    if indicator_iter==3

br_viol_perc_dic=Dict{Array{Int64,1},Float64}()
br_viol_perc_c_dic=Dict{Array{Int64,1},Float64}()

for t in 1:nTP
    if ~isempty(branch_flow_check[t][3])
        # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
            for k in branch_flow_check[t][2][1]
                j=indexin(k ,branch_flow_check[t][2][1])

 push!(br_viol_perc_dic, [t,idx_from_line[k],idx_to_line[k]] => coeff_nr*(branch_flow_check[t][3][1][j[1]]-1))
 push!(br_viol_perc_dic, [t,idx_to_line[k],idx_from_line[k]] => coeff_nr*(branch_flow_check[t][3][1][j[1]]-1))

end
end
end





for c in 1:nCont, s in 1:nSc, t in 1:nTP
    if ~isempty(branch_flow_check_c[c,s,t][3])
        # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
            for k in branch_flow_check_c[c,s,t][2][1]
                j=indexin(k ,branch_flow_check_c[c,s,t][2][1])

 push!(br_viol_perc_c_dic, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>coeff_c*(branch_flow_check_c[c,s,t][3][j[1]]-1))
 push!(br_viol_perc_c_dic, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>coeff_c*(branch_flow_check_c[c,s,t][3][j[1]]-1))

end
end
end
if isempty(br_viol_perc_dic)
    # for   t in 1:nTP, b in 1:nBus
        push!(br_viol_perc_dic, [1] => 0)
        # push!(br_viol_perc_dic, [1] => 0)
    # end
end
if isempty(br_viol_perc_c_dic)
    # for   t in 1:nTP, b in 1:nBus
        push!(br_viol_perc_c_dic, [1] => 0)
        # push!(br_viol_perc_c_dic, [1] => 0)
    # end
end

maximum_br_violation_normal=(1/coeff_nr)*findmax(br_viol_perc_dic)[1]
maximum_br_violation_contin=(1/coeff_c)*findmax(br_viol_perc_c_dic)[1]
total_br_violation_normal=(1/coeff_nr)*reduce(+,values(br_viol_perc_dic),init=0)
total_br_violation_contin=(1/coeff_c)*reduce(+,values(br_viol_perc_c_dic),init=0)
return br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin
elseif indicator_iter==4


    br_viol_perc_dic_iter=Dict{Array{Int64,1},Float64}()
    br_viol_perc_c_dic_iter=Dict{Array{Int64,1},Float64}()

    for  t in 1:nTP
        if ~isempty(branch_flow_check[t][3])
            # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
                for k in branch_flow_check[t][2][1]
                    j=indexin(k ,branch_flow_check[t][2][1])
           if  !haskey(br_viol_perc_dic,[t,idx_from_line[k],idx_to_line[k]])
     push!(br_viol_perc_dic, [t,idx_from_line[k],idx_to_line[k]] => coeff_nr*(branch_flow_check[t][3][1][j[1]]-1.0))
     push!(br_viol_perc_dic, [t,idx_to_line[k],idx_from_line[k]] => coeff_nr*(branch_flow_check[t][3][1][j[1]]-1.0))

     push!(br_viol_perc_dic_iter, [t,idx_from_line[k],idx_to_line[k]] => (branch_flow_check[t][3][1][j[1]]-1.0))
     push!(br_viol_perc_dic_iter, [t,idx_to_line[k],idx_from_line[k]] => (branch_flow_check[t][3][1][j[1]]-1.0))
       elseif  haskey(br_viol_perc_dic,[t,idx_from_line[k],idx_to_line[k]])
           push!(br_viol_perc_dic, [t,idx_from_line[k],idx_to_line[k]] => br_viol_perc_dic[[t,idx_from_line[k],idx_to_line[k]]] +coeff_compl*((branch_flow_check[t][3][1][j[1]]-1.0))-tighten_flag*tighten_coef_old*((branch_flow_check[t][3][1][j[1]]-1.0))      )
           push!(br_viol_perc_dic, [t,idx_to_line[k],idx_from_line[k]] => br_viol_perc_dic[[t,idx_to_line[k],idx_from_line[k]]] +coeff_compl*((branch_flow_check[t][3][1][j[1]]-1.0))-tighten_flag*tighten_coef_old*((branch_flow_check[t][3][1][j[1]]-1.0))      )
           # push!(br_viol_perc_dic, [t,idx_from_line[k],idx_to_line[k]] => br_viol_perc_dic[[t,idx_from_line[k],idx_to_line[k]]] +coeff_compl*((branch_flow_check[t][3][1][j[1]]-1.0))    )
           # push!(br_viol_perc_dic, [t,idx_to_line[k],idx_from_line[k]] => br_viol_perc_dic[[t,idx_to_line[k],idx_from_line[k]]] +coeff_compl*((branch_flow_check[t][3][1][j[1]]-1.0))    )

           push!(br_viol_perc_dic_iter, [t,idx_from_line[k],idx_to_line[k]] => (branch_flow_check[t][3][1][j[1]]-1.0))
           push!(br_viol_perc_dic_iter, [t,idx_to_line[k],idx_from_line[k]] => (branch_flow_check[t][3][1][j[1]]-1.0))
       end
    end
    end
    end





    for c in 1:nCont, s in 1:nSc, t in 1:nTP
        if ~isempty(branch_flow_check_c[c,s,t][3])
            # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
                for k in branch_flow_check_c[c,s,t][2][1]
                    j=indexin(k ,branch_flow_check_c[c,s,t][2][1])
                 if !haskey(br_viol_perc_c_dic,[c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]])
     push!(br_viol_perc_c_dic, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>coeff_c*(branch_flow_check_c[c,s,t][3][j[1]]-1))
     push!(br_viol_perc_c_dic, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>coeff_c*(branch_flow_check_c[c,s,t][3][j[1]]-1))

     push!(br_viol_perc_c_dic_iter, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>(branch_flow_check_c[c,s,t][3][j[1]]-1))
     push!(br_viol_perc_c_dic_iter, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>(branch_flow_check_c[c,s,t][3][j[1]]-1))
                elseif haskey(br_viol_perc_c_dic,[c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]])
                    push!(br_viol_perc_c_dic, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]]] +coeff_compl*((branch_flow_check_c[c,s,t][3][j[1]]-1))-tighten_flag*tighten_coef_old*((branch_flow_check_c[c,s,t][3][j[1]]-1)) )
                    push!(br_viol_perc_c_dic, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>br_viol_perc_c_dic[[c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]]] +coeff_compl*((branch_flow_check_c[c,s,t][3][j[1]]-1))-tighten_flag*tighten_coef_old*((branch_flow_check_c[c,s,t][3][j[1]]-1)))
                    # push!(br_viol_perc_c_dic, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>br_viol_perc_c_dic[[c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]]] +coeff_compl*((branch_flow_check_c[c,s,t][3][j[1]]-1)) )
                    # push!(br_viol_perc_c_dic, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>br_viol_perc_c_dic[[c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]]] +coeff_compl*((branch_flow_check_c[c,s,t][3][j[1]]-1)) )

                    push!(br_viol_perc_c_dic_iter, [c,s,t,idx_from_line_c[c][k],idx_to_line_c[c][k]] =>(branch_flow_check_c[c,s,t][3][j[1]]-1))
                    push!(br_viol_perc_c_dic_iter, [c,s,t,idx_to_line_c[c][k],idx_from_line_c[c][k]] =>(branch_flow_check_c[c,s,t][3][j[1]]-1))
end
    end
    end
    end
    if isempty(br_viol_perc_dic_iter)
        # for   t in 1:nTP, b in 1:nBus
            push!(br_viol_perc_dic_iter, [1] => 0)
            # push!(br_viol_perc_dic_iter, [1] => 0)
        # end
    end
    if isempty(br_viol_perc_c_dic_iter)
        # for   t in 1:nTP, b in 1:nBus
            push!(br_viol_perc_c_dic_iter, [1] => 0)
            # push!(br_viol_perc_c_dic, [1] => 0)
        # end
    end
    maximum_br_violation_normal=findmax(br_viol_perc_dic_iter)[1]
    maximum_br_violation_contin=findmax(br_viol_perc_c_dic_iter)[1]
    total_br_violation_normal=reduce(+,values(br_viol_perc_dic_iter),init=0)
    total_br_violation_contin=reduce(+,values(br_viol_perc_c_dic_iter),init=0)
    return br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin


end
end



function voltage_violation_value(indicator_iter,coeff_nr,coeff_c,coeff_compl,voltage_violation,tighten_flag)
    if indicator_iter==3

vol_viol_val_dic_min=Dict{Array{Int64,1},Float64}()
vol_viol_val_dic_max=Dict{Array{Int64,1},Float64}()
vol_viol_val_c_dic_min=Dict{Array{Int64,1},Float64}()
vol_viol_val_c_dic_max=Dict{Array{Int64,1},Float64}()

voltage_violation=Dict(
"vol_viol_val_dic_min"=>vol_viol_val_dic_min,
"vol_viol_val_dic_max"=>vol_viol_val_dic_max,
"vol_viol_val_c_dic_min"=>vol_viol_val_c_dic_min,
"vol_viol_val_c_dic_max"=>vol_viol_val_c_dic_max

)

for t in 1:nTP, b in 1:nBus
    if haskey(volt_viol_normal,[t,b])
        # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
            if volt_viol_normal[[t,b]]<nw_buses[b].bus_vmin

 push!(voltage_violation[ "vol_viol_val_dic_min"], [t,b] => coeff_nr*(nw_buses[b].bus_vmin-volt_viol_normal[[t,b]]))
 push!(voltage_violation[ "vol_viol_val_dic_max"], [t,b] => 0)

elseif volt_viol_normal[[t,b]]>nw_buses[b].bus_vmax
 push!(voltage_violation[ "vol_viol_val_dic_min"], [t,b] => 0)
 push!(voltage_violation[ "vol_viol_val_dic_max"], [t,b] => coeff_nr*(volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax))
end

end
end





for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
    if haskey(volt_viol_contin,[c,s,t,b])
        # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
            if volt_viol_contin[[c,s,t,b]]<nw_buses[b].bus_vmin-v_relax_factor_min

 push!(voltage_violation[ "vol_viol_val_c_dic_min"], [c,s,t,b] =>coeff_c*(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]]))
 push!(voltage_violation[ "vol_viol_val_c_dic_max"], [c,s,t,b] =>0)
elseif volt_viol_contin[[c,s,t,b]]>nw_buses[b].bus_vmax+v_relax_factor_max
 push!(voltage_violation[ "vol_viol_val_c_dic_min"], [c,s,t,b] =>0)
 push!(voltage_violation[ "vol_viol_val_c_dic_max"], [c,s,t,b] =>coeff_c*(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max))

end
end
end

if isempty(volt_viol_normal)
    for   t in 1:nTP, b in 1:nBus
        push!(voltage_violation[ "vol_viol_val_dic_min"], [t,b] => 0)
        push!(voltage_violation[ "vol_viol_val_dic_max"], [t,b] => 0)
    end
end
if isempty(volt_viol_contin)
    for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
        push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>0)
        push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>0)
    end
end


maximum_volt_violation_nr=(1/coeff_nr)*maximum( [findmax(voltage_violation[ "vol_viol_val_dic_min"])[1] findmax(voltage_violation[ "vol_viol_val_dic_max"])[1]] )
maximum_volt_violation_c=(1/coeff_c)*maximum( [findmax(voltage_violation[ "vol_viol_val_c_dic_min"])[1] findmax(voltage_violation[ "vol_viol_val_c_dic_max"])[1]] )
maximum_volt_violation_normal=[]
maximum_volt_violation_contin=[]
push!(maximum_volt_violation_normal, [[transpose(findmax(voltage_violation[ "vol_viol_val_dic_min"])[2])] maximum_volt_violation_nr])
push!(maximum_volt_violation_contin, [[transpose(findmax(voltage_violation[ "vol_viol_val_c_dic_min"])[2])] maximum_volt_violation_c])

total_volt_violation_nr=(1/coeff_nr)*(reduce(+,values(voltage_violation["vol_viol_val_dic_min"]),init=0)+reduce(+,values(voltage_violation["vol_viol_val_dic_max"]),init=0))
total_volt_violation_c =(1/coeff_c)*(reduce(+,values(voltage_violation["vol_viol_val_c_dic_min"]),init=0)+reduce(+,values(voltage_violation["vol_viol_val_c_dic_max"]),init=0))
return voltage_violation,maximum_volt_violation_normal,maximum_volt_violation_contin,total_volt_violation_nr,total_volt_violation_c


elseif indicator_iter==4

    vol_viol_val_dic_min_iter=Dict{Array{Int64,1},Float64}()
    vol_viol_val_dic_max_iter=Dict{Array{Int64,1},Float64}()
    vol_viol_val_c_dic_min_iter=Dict{Array{Int64,1},Float64}()
    vol_viol_val_c_dic_max_iter=Dict{Array{Int64,1},Float64}()


    for   t in 1:nTP, b in 1:nBus
        if haskey(volt_viol_normal,[t,b]) && !haskey(voltage_violation["vol_viol_val_dic_min"],[t,b])
            # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
                if volt_viol_normal[[t,b]]<nw_buses[b].bus_vmin

     push!(voltage_violation["vol_viol_val_dic_min"], [t,b] => coeff_nr*(nw_buses[b].bus_vmin-volt_viol_normal[[t,b]]))
     push!(voltage_violation["vol_viol_val_dic_max"], [t,b] => 0)
     push!(vol_viol_val_dic_min_iter, [t,b] => (nw_buses[b].bus_vmin-volt_viol_normal[[t,b]]))
     push!(vol_viol_val_dic_max_iter, [t,b] => 0)

    elseif volt_viol_normal[[t,b]]>nw_buses[b].bus_vmax
     push!(voltage_violation["vol_viol_val_dic_min"], [t,b] => 0)
     push!(voltage_violation["vol_viol_val_dic_max"], [t,b] =>coeff_nr* (volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax))
     push!(vol_viol_val_dic_min_iter, [t,b] => 0)
     push!(vol_viol_val_dic_max_iter, [t,b] => (volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax))

    end
elseif haskey(volt_viol_normal,[t,b]) && haskey(voltage_violation["vol_viol_val_dic_min"],[t,b])
    if volt_viol_normal[[t,b]]<nw_buses[b].bus_vmin
        push!(voltage_violation["vol_viol_val_dic_min"], [t,b] => voltage_violation["vol_viol_val_dic_min"][[t,b]]+coeff_compl*((nw_buses[b].bus_vmin-volt_viol_normal[[t,b]]))-tighten_flag*tighten_coef_old*((nw_buses[b].bus_vmin-volt_viol_normal[[t,b]])) )
        # push!(voltage_violation["vol_viol_val_dic_min"], [t,b] => voltage_violation["vol_viol_val_dic_min"][[t,b]]+coeff_compl*((nw_buses[b].bus_vmin-volt_viol_normal[[t,b]])) )

        push!(voltage_violation["vol_viol_val_dic_max"], [t,b] => 0)

        push!(vol_viol_val_dic_min_iter, [t,b] => (nw_buses[b].bus_vmin-volt_viol_normal[[t,b]]))
        push!(vol_viol_val_dic_max_iter, [t,b] => 0)
    elseif volt_viol_normal[[t,b]]>nw_buses[b].bus_vmax
        push!(voltage_violation["vol_viol_val_dic_min"], [t,b] => 0)
        push!(voltage_violation["vol_viol_val_dic_max"], [t,b] =>voltage_violation["vol_viol_val_dic_max"][[t,b]] +coeff_compl* ((volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax))-tighten_flag*tighten_coef_old*((volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax)) )
        # push!(voltage_violation["vol_viol_val_dic_max"], [t,b] =>voltage_violation["vol_viol_val_dic_max"][[t,b]] +coeff_compl* ((volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax)) )

        push!(vol_viol_val_dic_min_iter, [t,b] => 0)
        push!(vol_viol_val_dic_max_iter, [t,b] => (volt_viol_normal[[t,b]]-nw_buses[b].bus_vmax))

end
    end
    end





    for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
        if haskey(volt_viol_contin,[c,s,t,b]) && !haskey(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] )
            # for j in 1:size(br_viol_check_contin[c,s,t][3][1],1)
                if volt_viol_contin[[c,s,t,b]]<nw_buses[b].bus_vmin-v_relax_factor_min

     push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>coeff_c*(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]]))
     push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>0)
     push!(vol_viol_val_c_dic_min_iter, [c,s,t,b] =>(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]]))
     push!(vol_viol_val_c_dic_max_iter, [c,s,t,b] =>0)

 elseif volt_viol_contin[[c,s,t,b]]>nw_buses[b].bus_vmax+v_relax_factor_max
     push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>0)
     push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>coeff_c*(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max))
     push!(vol_viol_val_c_dic_min_iter, [c,s,t,b] =>0)
     push!(vol_viol_val_c_dic_max_iter, [c,s,t,b] =>(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max))
    end
elseif haskey(volt_viol_contin,[c,s,t,b]) && haskey(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] )
    if volt_viol_contin[[c,s,t,b]]<nw_buses[b].bus_vmin-v_relax_factor_min
        push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>(voltage_violation["vol_viol_val_c_dic_min"][[c,s,t,b]] + coeff_compl*(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]])-tighten_flag*tighten_coef_old*(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]])))
        # push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>(voltage_violation["vol_viol_val_c_dic_min"][[c,s,t,b]] + coeff_compl*(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]]) ))
        push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>0)

        push!(vol_viol_val_c_dic_min_iter, [c,s,t,b] =>(nw_buses[b].bus_vmin-v_relax_factor_min-volt_viol_contin[[c,s,t,b]]))
        push!(vol_viol_val_c_dic_max_iter, [c,s,t,b] =>0)
    elseif volt_viol_contin[[c,s,t,b]]>nw_buses[b].bus_vmax+v_relax_factor_max
        push!(voltage_violation["vol_viol_val_c_dic_min"], [c,s,t,b] =>0)
        push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>(voltage_violation["vol_viol_val_c_dic_max"][[c,s,t,b]] + coeff_compl*(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max)-tighten_flag*tighten_coef_old*(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max)))
        # push!(voltage_violation["vol_viol_val_c_dic_max"], [c,s,t,b] =>(voltage_violation["vol_viol_val_c_dic_max"][[c,s,t,b]] + coeff_compl*(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max) ))

        push!(vol_viol_val_c_dic_min_iter, [c,s,t,b] =>0)
        push!(vol_viol_val_c_dic_max_iter, [c,s,t,b] =>(volt_viol_contin[[c,s,t,b]]-nw_buses[b].bus_vmax-v_relax_factor_max))
end
    end
    end
    # volt_violation=Dict(
    # "vol_viol_val_dic_min"=>vol_viol_val_dic_min,
    # "vol_viol_val_dic_max"=>vol_viol_val_dic_max,
    # "vol_viol_val_c_dic_min"=>vol_viol_val_c_dic_min,
    # "vol_viol_val_c_dic_max"=>vol_viol_val_c_dic_max
    #
    # )
if isempty(volt_viol_normal)
    for   t in 1:nTP, b in 1:nBus
        push!(vol_viol_val_dic_min_iter, [t,b] => 0)
        push!(vol_viol_val_dic_max_iter, [t,b] => 0)
    end
end
if isempty(volt_viol_contin)
    for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
        push!(vol_viol_val_c_dic_min_iter, [c,s,t,b] =>0)
        push!(vol_viol_val_c_dic_max_iter, [c,s,t,b] =>0)
    end
end



    maximum_volt_violation_nr=maximum( [findmax(vol_viol_val_dic_min_iter)[1] findmax(vol_viol_val_dic_max_iter)[1]] )
    maximum_volt_violation_c=maximum( [findmax(vol_viol_val_c_dic_min_iter)[1] findmax(vol_viol_val_c_dic_max_iter)[1]] )
    maximum_volt_violation_normal=[]
    maximum_volt_violation_contin=[]
    push!(maximum_volt_violation_normal, [[transpose(findmax(vol_viol_val_dic_min_iter)[2])] maximum_volt_violation_nr])
    push!(maximum_volt_violation_contin, [[transpose(findmax(vol_viol_val_c_dic_min_iter)[2])] maximum_volt_violation_c])

    total_volt_violation_nr=(reduce(+,values(vol_viol_val_dic_min_iter),init=0)+reduce(+,values(vol_viol_val_dic_max_iter),init=0))
    total_volt_violation_c =(reduce(+,values(vol_viol_val_c_dic_min_iter),init=0)+reduce(+,values(vol_viol_val_c_dic_max_iter),init=0))
    return voltage_violation,maximum_volt_violation_normal,maximum_volt_violation_contin,total_volt_violation_nr,total_volt_violation_c


end
end


function DC_SCOPF(type,iteration,state_dependent,included_line_indicator,violated_line_indicator)
    # if iter!=1
    #   empty!(model_name)
    #   GC.gc()
    # end

model_name=direct_model(CPLEX.Optimizer())
# using Ipopt
# trac_SCOPF_S1=Model(Ipopt.Optimizer)
# function DC_SCOPF(model_name,type)

# model_name=name_of_model
if type=="scopf"
(v_sq, teta, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc)=variables_t_n(model_name)
# (v_sq_c, teta_c, Pg_c, Qg_c, pen_ws_c, pen_lsh_c, p_fl_inc_c, p_fl_dec_c, p_ch_c, p_dis_c, soc_c,slack_pb_p_c,slack_pb_n_c)=variables_t_c(model_name)
(v_sq_c, teta_c, Pg_c, Qg_c, pen_ws_c, pen_lsh_c, p_fl_inc_c, p_fl_dec_c, p_ch_c, p_dis_c, soc_c)=variables_t_c(model_name)

global  v_sq=v_sq
global  teta=teta
global  Pg=Pg
global  Qg=Qg
global  pen_ws=pen_ws
global  pen_lsh=pen_lsh
global  p_fl_inc=p_fl_inc
global  p_fl_dec=p_fl_dec
global  p_ch=p_ch
global  p_dis=p_dis
global  soc=soc

global  v_sq_c=v_sq_c
global  teta_c=teta_c
global  Pg_c=Pg_c
global  Qg_c=Qg_c
global  pen_ws_c=pen_ws_c
global  pen_lsh_c=pen_lsh_c
global  p_fl_inc_c=p_fl_inc_c
global  p_fl_dec_c=p_fl_dec_c
global  p_ch_c=p_ch_c
global  p_dis_c=p_dis_c
global  soc_c=soc_c
# global slack_pb_p_c=slack_pb_p_c
# global slack_pb_n_c=slack_pb_n_c
##------voltage_constraint----------
(vol_n1,vol_n2,vol_n3,vol_n4)= voltage_cons_t_n(model_name, iteration)  #1 is the first iteration
(vol_c1,vol_c2,vol_c3,vol_c4)= voltage_cons_t_c(model_name, iteration) #1 is the first iteration
##-------gen limits-----------------
gen_limits_t_n(model_name)
gen_limits_t_c(model_name)

if nFl!=0
FL_cons_normal_t(model_name)
FL_cons_contin_t(model_name)
end
if nStr_active!=0
storage_cons_normal_t(model_name)
storage_cons_contin_t(model_name)
end
##-------power balance normal--------
println("")
show("Normal line expression took:")
println("")
@time (pinj_dict,pinj_dict_l,ploss_dic,qinj_dict,qinj_dict_l,ploss_trans_dic)                    = line_expression_t_n(model_name,from_to_map_t,state_dependent)
println("")
show("Contin line expression took:")
println("")
@time (pinj_dict_c, pinj_dict_l_c, ploss_c_dict, qinj_dict_c,qinj_dict_l_c,ploss_trans_dic_c)    = line_expression_t_c(model_name,from_to_map_t,state_dependent)
# local pinj_dict=pinj_dict
# local pinj_dict_l=pinj_dict_l
# local ploss_dic=ploss_dic
# local qinj_dict=qinj_dict
# local qinj_dict_l=qinj_dict_l
# local ploss_trans_dic=ploss_trans_dic
#
global   pinj_dict_c=pinj_dict_c
global   pinj_dict_l_c=pinj_dict_l_c
global   ploss_c_dict=ploss_c_dict
global   qinj_dict_c=qinj_dict_c
global   qinj_dict_l_c=qinj_dict_l_c
global   ploss_trans_dic_c=ploss_trans_dic_c
println("")
show("Normal power balance took:")
println("")
@time (active_power_balance_normal,reactive_power_balance_normal) =power_balance_t_n(model_name)

println("")
show("Contin power balance took:")
println("")
@time (active_power_balance_contin,reactive_power_balance_contin) =power_balance_t_c(model_name)

# included_line_indicator=0
# violated_line_indicator=0
# line_flow_t_n_full(model_name,included_line_indicator,violated_line_indicator)
# line_flow_t_c_full(model_name, included_line_indicator,violated_line_indicator)


(line_flow_normal_L1,line_flow_normal_L2,line_flow_normal_L3, line_flow_normal_L4,line_flow_normal_L5,line_flow_normal_L6,line_flow_normal_L7,line_flow_normal_L8)=line_flow_t_n_half(model_name,included_line_indicator,violated_line_indicator)
(line_flow_contin_L1, line_flow_contin_L2,line_flow_contin_L3, line_flow_contin_L4,line_flow_contin_L5,line_flow_contin_L6,line_flow_contin_L7,line_flow_contin_L8)=line_flow_t_c_half(model_name, included_line_indicator,violated_line_indicator)



# loss_gr_zero_n(1,ploss_dic,ploss_trans_dic,v_sq)
# loss_gr_zero_c(1) #no restriction for the lines just for the transformers
#
# if iteration<=2
@constraint(model_name, loss_gr_zero_n_from[ t in 1:nTP, l in 1:nLines],
ploss_dic[[t,idx_from_line[l],idx_to_line[l]]]>=0)
#
# @constraint(model_name, loss_gr_zero_n_to[ t in 1:nTP, l in 1:nLines],
# ploss_dic[[t,idx_to_line[l],idx_from_line[l]]]<=0)

#
# @constraint(model_name, loss_gr_zero_n_from_trans[ t in 1:nTP, l in 1:size(nw_trans,1)],
# ploss_trans_dic[[t,nw_trans[l].trans_bus_from,nw_trans[l].trans_bus_to]]>=0)
# #
# @constraint(model_name, loss_gr_zero_n_to_trans[ t in 1:nTP, l in 1:size(nw_trans,1)],
# ploss_trans_dic[[t,nw_trans[l].trans_bus_to,nw_trans[l].trans_bus_from]]>=0)
#
#
#
@constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
ploss_c_dict[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]>=0)
# #
# @constraint(model_name, [c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])],
# ploss_c_dict[[c,s,t,idx_to_line_c[c][l],idx_from_line_c[c][l]]]>=0)
#
# @constraint(model_name, loss_gr_zero_c_from_trans[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
# ploss_trans_dic_c[[c,s,t,nw_trans[l].trans_bus_from,nw_trans[l].trans_bus_to]]>=0)
#
# # # @constraint(model_name, loss_gr_zero_c_to_trans[c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:size(nw_trans,1)],
# # # ploss_trans_dic_c[[c,s,t,nw_trans[l].trans_bus_to,nw_trans[l].trans_bus_from]]>=0)
# end
# display("normal power balance constraints are generated.")
# display("Post contingency power balance constraints are generated.")

coupling_constraint_t(model_name)


(total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str,cost_pen_ws,cost_pen_lsh_c,cost_pen_ws_c,cost_fl_c,cost_str_c)=objective_t_SCOPF(model_name)

global cost_gen=cost_gen
global cost_pen_lsh=cost_pen_lsh
global cost_fl=cost_fl
global cost_str=cost_str
global cost_pen_lsh_c=cost_pen_lsh_c
global cost_pen_ws=cost_pen_ws
global cost_pen_ws_c=cost_pen_ws_c
global cost_fl_c=cost_fl_c
global cost_str_c=cost_str_c
display("Objectives are set.")

set_optimizer_attribute(model_name, "CPX_PARAM_LPMETHOD",4)
set_optimizer_attribute(model_name, "CPX_PARAM_SOLUTIONTYPE", 2)
set_optimizer_attribute(model_name, "CPX_PARAM_BAREPCOMP",  5e-4)
# set_optimizer_attribute(model_name, "CPX_PARAM_BARALG", 3)

#no major improve attibutes
# set_optimizer_attribute(model_name, "CPX_PARAM_BARORDER", 0)# 1(25 to 16),2(no improve),3
# set_optimizer_attribute(model_name, "CPX_PARAM_DEPIND", 1)
# set_optimizer_attribute(model_name, "CPX_PARAM_BARSTARTALG", 2)#2 outperforms others
# set_optimizer_attribute(model_name, "CPX_PARAM_BARGROWTH", 10)
optimize!(model_name)
show(termination_status(model_name))
println("")
if termination_status(model_name)==MathOptInterface.OPTIMAL || termination_status(model_name)==MathOptInterface.LOCALLY_SOLVED  || termination_status(model_name)==MathOptInterface.ALMOST_OPTIMAL || termination_status(model_name)==MathOptInterface.ALMOST_LOCALLY_SOLVED
show("Objective value ")
println("")
show(JuMP.objective_value(model_name))
println("")
show("Solver Time ")
println("")
show(JuMP.solve_time(model_name))
println("")
else
global    infeas_flag=1
    show("infeasible problem is detected and Flag is raised.")
global    BreakingPoint = true

end
bounded_segment_n=nothing
bounded_segment_c=nothing
# (bounded_segment_n,bounded_segment_c)=dualizing(
# line_flow_normal_L1,
# line_flow_normal_L2,
# line_flow_normal_L3,
# line_flow_normal_L4,
# line_flow_contin_L1,
# line_flow_contin_L2,
# line_flow_contin_L3,
# line_flow_contin_L4,
#
#     )

return model_name, bounded_segment_n,bounded_segment_c,infeas_flag
end
if type=="opf"
    (v_sq, teta, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc) =variables_t_n(model_name)
    # (v_sq_c, teta_c, Pg_c, Qg_c, pen_ws_c, pen_lsh_c, p_fl_inc_c, p_fl_dec_c,p_ch_c,p_dis_c,soc_c)   =variables_t_c(model_name)
    global  v_sq=v_sq
    global  teta=teta
    global  Pg=Pg
    global  Qg=Qg
    global  pen_ws=pen_ws
    global  pen_lsh=pen_lsh
    global  p_fl_inc=p_fl_inc
    global  p_fl_dec=p_fl_dec
    global  p_ch=p_ch
    global  p_dis=p_dis
    global  soc=soc
# global  v_sq_c=v_sq_c
# global  teta_c=teta_c
# global Pg_c=Pg_c
# global  Qg_c=Qg_c
##------voltage_constraint----------
(vol_n1,vol_n2,vol_n3,vol_n4)= voltage_cons_t_n(model_name, iteration)  #1 is the first iteration
# (vol_c1,vol_c2,vol_c3,vol_c4)= voltage_cons_t_c(model_name, 1) #1 is the first iteration
##-------gen limits-----------------
gen_limits_t_n(model_name)

FL_cons_normal_t(model_name)
# FL_cons_contin()

# storage_cons_normal_t(model_name)
# storage_cons_contin()
# gen_limits_t_c(model_name)
##-------power balance normal--------
(pinj_dict,pinj_dict_l,ploss_dic,qinj_dict,qinj_dict_l,ploss_trans_dic)                    = line_expression_t_n(model_name,from_to_map_t,state_dependent)
# (pinj_dict_c, pinj_dict_l_c, ploss_c_dict, qinj_dict_c,qinj_dict_l_c,ploss_trans_dic_c)    = line_expression_t_c(1)
global pinj_dict=pinj_dict
global pinj_dict_l=pinj_dict_l
global ploss_dic=ploss_dic
global qinj_dict=qinj_dict
global qinj_dict_l=qinj_dict_l
global ploss_trans_dic=ploss_trans_dic

# global   pinj_dict_c=pinj_dict_c
# global   pinj_dict_l_c=pinj_dict_l_c
# global   ploss_c_dict=ploss_c_dict
# global   qinj_dict_c=qinj_dict_c
# global   qinj_dict_l_c=qinj_dict_l_c
# global   ploss_trans_dic_c=ploss_trans_dic_c
(active_power_balance_normal,reactive_power_balance_normal) =power_balance_t_n(model_name)
# (active_power_balance_contin,reactive_power_balance_contin) =power_balance_t_c(model_name)

# included_line_indicator=0
# violated_line_indicator=0

line_flow_t_n_half(model_name,included_line_indicator,violated_line_indicator)

# loss_gr_zero_n(1)
# loss_gr_zero_c(1) #no restriction for the lines just for the transformers
# @constraint(model_name, loss_gr_zero_n_from[ t in 1:nTP, l in 1:nLines],
# ploss_dic[[t,idx_from_line[l],idx_to_line[l]]]>=0)
#
# @constraint(model_name, loss_gr_zero_n_to[ t in 1:nTP, l in 1:nLines],
# ploss_dic[[t,idx_to_line[l],idx_from_line[l]]]>=0)
#
# @constraint(model_name, loss_gr_zero_n_from_trans[ t in 1:nTP, l in 1:size(nw_trans,1)],
# ploss_trans_dic[[t,nw_trans[l].trans_bus_from,nw_trans[l].trans_bus_to]]>=0)
#
# @constraint(model_name, loss_gr_zero_n_to_trans[ t in 1:nTP, l in 1:size(nw_trans,1)],
# ploss_trans_dic[[t,nw_trans[l].trans_bus_to,nw_trans[l].trans_bus_from]]>=0)

# display("normal power balance constraints are generated.")
# display("Post contingency power balance constraints are generated.")

# coupling_constraint_t(model_name)


(total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str,cost_pen_ws)=objective_t_OPF(model_name)

global cost_gen=cost_gen
global cost_pen_lsh=cost_pen_lsh
global cost_fl=cost_fl
global cost_str=cost_str
global cost_pen_ws=cost_pen_ws
display("Objectives are set.")


set_optimizer_attribute(model_name, "CPX_PARAM_LPMETHOD",4)
set_optimizer_attribute(model_name, "CPX_PARAM_SOLUTIONTYPE", 2)
set_optimizer_attribute(model_name, "CPX_PARAM_BAREPCOMP", 5e-4)
set_optimizer_attribute(model_name, "CPX_PARAM_BARORDER", 1)# 1(25 to 16),2(no improve),3

optimize!(model_name)
println(termination_status(model_name))
println("Objective value ", JuMP.objective_value(model_name))
println("Solver Time ", JuMP.solve_time(model_name))
end

bounded_segment_n=nothing
bounded_segment_c=nothing
return model_name,bounded_segment_n,bounded_segment_c
end



# function dualizing()
# end

function dualizing(
line_flow_normal_L1,
line_flow_normal_L2,
line_flow_normal_L3,
line_flow_normal_L4,
line_flow_contin_L1,
line_flow_contin_L2,
line_flow_contin_L3,
line_flow_contin_L4,

    )

    line_flow_normal=Dict(
    :line_flow_normal_L1=>JuMP.dual.(line_flow_normal_L1),
    :line_flow_normal_L2=>JuMP.dual.(line_flow_normal_L2),
    :line_flow_normal_L3=>JuMP.dual.(line_flow_normal_L3),
    :line_flow_normal_L4=>JuMP.dual.(line_flow_normal_L4),
    # :line_flow_normal_L5=>JuMP.dual.(line_flow_normal_L5),
    # :line_flow_normal_L6=>JuMP.dual.(line_flow_normal_L6),
    # :line_flow_normal_L7=>JuMP.dual.(line_flow_normal_L7),
    # :line_flow_normal_L8=>JuMP.dual.(line_flow_normal_L8),
    )

    line_flow_contin=Dict(
    :line_flow_contin_L1=>JuMP.dual.(line_flow_contin_L1),
    :line_flow_contin_L2=>JuMP.dual.(line_flow_contin_L2),
    :line_flow_contin_L3=>JuMP.dual.(line_flow_contin_L3),
    :line_flow_contin_L4=>JuMP.dual.(line_flow_contin_L4),
    # :line_flow_contin_L5=>JuMP.dual.(line_flow_contin_L5),
    # :line_flow_contin_L6=>JuMP.dual.(line_flow_contin_L6),
    # :line_flow_contin_L7=>JuMP.dual.(line_flow_contin_L7),
    # :line_flow_contin_L8=>JuMP.dual.(line_flow_contin_L8),

    )
bounded_segment_1_c=Dict()
bounded_segment_2_c=Dict()
bounded_segment_3_c=Dict()
bounded_segment_4_c=Dict()
for c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])
    if line_flow_contin[:line_flow_contin_L1][c,s,t,l]>0.01
    push!(bounded_segment_1_c, [c,s,t,l]=>1)
elseif line_flow_contin[:line_flow_contin_L2][c,s,t,l]>0.01
    push!(bounded_segment_2_c, [c,s,t,l]=>1)
elseif line_flow_contin[:line_flow_contin_L3][c,s,t,l]>0.01
    push!(bounded_segment_3_c, [c,s,t,l]=>1)
elseif line_flow_contin[:line_flow_contin_L4][c,s,t,l]>0.01
    push!(bounded_segment_4_c, [c,s,t,l]=>1)
end
end

bounded_segment_c=Dict(
:bounded_segment_1_c=>bounded_segment_1_c,
:bounded_segment_2_c=>bounded_segment_2_c,
:bounded_segment_3_c=>bounded_segment_3_c,
:bounded_segment_4_c=>bounded_segment_4_c,
)

bounded_segment_1_n=Dict()
bounded_segment_2_n=Dict()
bounded_segment_3_n=Dict()
bounded_segment_4_n=Dict()
for  t in 1:nTP, l in 1:nLines
    if line_flow_normal[:line_flow_normal_L1][t,l]>0.01
    push!(bounded_segment_1_n, [t,l]=>1)
elseif line_flow_normal[:line_flow_normal_L2][t,l]>0.01
    push!(bounded_segment_2_n, [t,l]=>1)
elseif line_flow_normal[:line_flow_normal_L3][t,l]>0.01
    push!(bounded_segment_3_n, [t,l]=>1)
elseif line_flow_normal[:line_flow_normal_L4][t,l]>0.01
    push!(bounded_segment_4_n, [t,l]=>1)
end
end
bounded_segment_n=Dict(
:bounded_segment_1_n=>bounded_segment_1_n,
:bounded_segment_2_n=>bounded_segment_2_n,
:bounded_segment_3_n=>bounded_segment_3_n,
:bounded_segment_4_n=>bounded_segment_4_n,
)

return bounded_segment_n,bounded_segment_c
end

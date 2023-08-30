using Ipopt
#
# included_lines=radiality_filtering(node_data_new)
#
# #----------contingency set definittion--------
# header==["cont"; "From"; "To"]
# data=included_lines
# (nCont,
# array_contin_lines,
# idx_from_line,
# idx_to_line,
# idx_line,
# idx_from_line_c,
# idx_to_line_c,
# list_of_contingency_lines,
# idx_pll_aux,
# idx_npll,
# data_for_each_contingency)=interface_excel_contingencies(raw_data,header,data)
# (idx_from_line,idx_to_line,yij_line,yij_line_sh,idx_from_trans,idx_to_trans,yij_trans,yij_trans_sh,tap_ratio,tap_ratio_min,tap_ratio_max)=f_line_data(array_lines,nw_trans)
# (idx_from_line_c,idx_to_line_c,yij_line_c,yij_line_sh_c,line_smax_c)=f_lines_data_contin(data_for_each_contingency)
#
#
# node_data_contin=f_node_data_contin(nCont,nBus,nw_buses,idx_from_line_c,idx_to_line_c,yij_line_c,yij_line_sh_c,line_smax_c)



# filename="input_data/new_results_$nBus.ods"
# converged_PF=ods_readall(filename;sheetsNames=["PF"],innerType="Matrix") #p g v θ
# for i in 1:nGens
#       nw_gens[i].gen_Pg_avl=converged_PF["PF"][:,1][i]
#       nw_gens[i].gen_V_set=converged_PF["PF"][:,3][i]
# end
# nTP=1
# nSc=1
# using Ipopt
AC_SCOPF = Model(Ipopt.Optimizer)
model_name=AC_SCOPF

(e, f, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc)        =variables_n(model_name)
(vol_const_nr)=voltage_cons_n(model_name,"range")
gen_limits_n(model_name,"range")
(pinj_dict,qinj_dict)        =line_expression_n(model_name)

(active_power_balance_normal)=active_power_bal_n(model_name,pinj_dict)
(reactive_power_balance_normal)=reactive_power_bal_n(model_name,qinj_dict)

(line_flow_normal_s,line_flow_normal_r)=line_flow_n(model_name,pinj_dict,qinj_dict,"full" )


# total_cost=objective(model_name)
(total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str, cost_pen_ws)=objective_OPF(model_name)
set_optimizer_attributes(model_name,"tol"=>5e-4)
optimize!(model_name)
println("Objective value", JuMP.objective_value(model_name))
println("Solver Time ", JuMP.solve_time(model_name))



(v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c)=rect_to_polar("normal")
#
# v_gen=[voltage_gen[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]
# v_ang=[volt_ang[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]
#
# ods_write("input_data\\SA_results_$nBus.ods",Dict(("PF",1,1)=>[value.(Pg[1,1,:]) value.(Qg[1,1,:]) v_gen v_ang]) )
#-------------power flow tool-----
active_generation=zeros(nSc,nTP,nGens)
for s in 1:nSc, t in 1:nTP, i in 1:nGens
active_generation[s,t,i]=JuMP.value.(Pg[t,i])

end

voltage=zeros(nSc,nTP, nBus)
for s in 1:nSc, t in 1:nTP, i in 1:nBus
    voltage[s,t,i]=voltage_gen[t,i]
end
voltage_gen=voltage
 # (input_normal,input_contin,power_flow_normal_result2,power_flow_contin_result2)=power_flow("all","non_initial", "out_of_OPF","v_sqr",0,"SA")
 (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
          )=power_flow("all","non_initial", "out_of_OPF","v_sqr",0,"SA")
          # =power_flow("all","non_initial", "out_of_OPF","v_sqr",0,"SA")

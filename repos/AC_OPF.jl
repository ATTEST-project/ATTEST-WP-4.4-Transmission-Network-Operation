using Ipopt

# filename="input_data\\SA_results_$nBus.ods"
# converged_PF=ods_readall(filename;sheetsNames=["PF"],innerType="Matrix") #p g v θ
# for i in 1:nGens
#       nw_gens[i].gen_Pg_avl=converged_PF["PF"][:,1][i]
#       nw_gens[i].gen_V_set=converged_PF["PF"][:,3][i]
# end
# nSc=1
# nTP=1

AC_SCOPF = Model(Ipopt.Optimizer)
model_name=AC_SCOPF
JuMP.bridge_constraints(model_name)=false

model_name=AC_SCOPF
# set_optimizer_attributes(model_name,"mu_strategy"=>"adaptive")
set_optimizer_attributes(model_name,"tol"=>1e-05)
# set_optimizer_attributes(acopf,"mumps_mem_percent"=>100)
# set_optimizer_attributes(acopf,"barrier_tol_factor"=>1e-6)

(e, f, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc)                      =variables_n(model_name)
# (e_c, f_c, Pg_c, Qg_c)=variables_c(model_name)
(vol_const_nr)=voltage_cons_n(model_name,"range")
# (vol_const_cn)=voltage_cons_c(model_name,"range")
if nFl!=0
FL_cons_normal(model_name)
end
if nStr_active!=0
storage_cons_normal(model_name)
end
gen_limits_n(model_name,"range")
# gen_limits_c(model_name,"range")
(pinj_dict,qinj_dict)        =line_expression_n(model_name)
# (pinj_dict_c,qinj_dict_c,pinj_dict_c_sr,qinj_dict_c_sr)=line_expression_c(model_name)

(active_power_balance_normal)=active_power_bal_n(model_name,pinj_dict)
# (active_power_balance_contin)=active_power_bal_c(model_name,pinj_dict_c)
(reactive_power_balance_normal)=reactive_power_bal_n(model_name,qinj_dict)
# (reactive_power_balance_contin)=reactive_power_bal_c(model_name,qinj_dict_c)

(line_flow_normal_s,line_flow_normal_r)=line_flow_n(model_name,pinj_dict,qinj_dict,0 )
# (line_flow_contin_s,line_flow_contin_r)=line_flow_c(model_name,pinj_dict_c_sr,qinj_dict_c_sr,0 )

# coupling_constraint(model_name)

(total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str, cost_pen_ws)=objective_OPF(model_name)

set_optimizer_attributes(model_name,"tol"=>1e-05)
optimize!(model_name)
println("Objective value", JuMP.objective_value(model_name))
println("Solver Time ", JuMP.solve_time(model_name))

(v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c)=rect_to_polar("normal")
# # #
v_gen=[voltage_gen[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]
v_ang=[volt_ang[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]


(input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
         )=power_flow("normal","non_initial", "out_of_OPF","v_sqr",0,0)
empty_contin=0

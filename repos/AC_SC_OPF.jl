using Ipopt

# filename="input_data\\SA_results_$nBus.ods"
# converged_PF=ods_readall(filename;sheetsNames=["PF"],innerType="Matrix") #p g v θ
# for i in 1:nGens
#       nw_gens[i].gen_Pg_avl=converged_PF["PF"][:,1][i]
#       nw_gens[i].gen_V_set=converged_PF["PF"][:,3][i]
# end

# AC_SCOPF=Model(Ipopt.Optimizer, add_bridges= false)
# @variable(AC_SCOPF, x, lower_bound=0)
# @constraint(AC_SCOPF, x==1 )
# @objective(AC_SCOPF, Min, sum(x))
# optimize!(AC_SCOPF)
# AC_SCOPF= direct_model(Ipopt.Optimizer())



# AC_SCOPF = Model(Ipopt.Optimizer, bridge_constraints=false)
AC_SCOPF = Model(Ipopt.Optimizer)
model_name=AC_SCOPF
JuMP.bridge_constraints(model_name)=false

# set_optimizer_attributes(model_name,"mu_strategy"=>"adaptive")
set_optimizer_attributes(model_name,"tol"=>5e-04)

set_optimizer_attributes(model_name,"mumps_mem_percent"=>100)
# set_optimizer_attributes(acopf,"barrier_tol_factor"=>1e-6)
show(now() )
println("")
show("Model starts now")
(e, f, Pg, Qg, pen_ws, pen_lsh, p_fl_inc, p_fl_dec, p_ch, p_dis, soc)                      =variables_n(model_name)
(e_c, f_c, Pg_c, Qg_c, pen_ws_c, pen_lsh_c, p_fl_inc_c ,p_fl_dec_c, p_ch_c, p_dis_c, soc_c)=variables_c(model_name)
show(now())
println("")
show("variables are generated")

(vol_const_nr)=voltage_cons_n(model_name,"range")
(vol_const_cn)=voltage_cons_c(model_name,"range")
gen_limits_n(model_name,"range")
gen_limits_c(model_name,"range")
if nFl!=0
FL_cons_normal(model_name)
FL_cons_contin(model_name)
end
if nStr_active!=0
storage_cons_normal(model_name)
storage_cons_contin(model_name)
end
show(now())
println("")
show("volt+gnelim+fl+str are generated")
(pinj_dict,qinj_dict)        =line_expression_n(model_name)
show(now())
println("")
show("line expr normal")
(pinj_dict_c,qinj_dict_c)=   line_expression_c(model_name)
show(now())
println("")
show("line expr contin")
(active_power_balance_normal)=active_power_bal_n(model_name,pinj_dict)
show(now())
println("")
show("power bal norm")
(active_power_balance_contin)=active_power_bal_c(model_name,pinj_dict_c)
show(now())
println("")
show("power bal contin")
(reactive_power_balance_normal)=reactive_power_bal_n(model_name,qinj_dict)
show(now())
println("")
show("react power bal normal")
(reactive_power_balance_contin)=reactive_power_bal_c(model_name,qinj_dict_c)
show(now())
println("")
show("react power bal contin")
(line_flow_normal_s,line_flow_normal_r)=line_flow_n(model_name,pinj_dict,qinj_dict,0 )# "full"
(line_flow_contin_s,line_flow_contin_r)=line_flow_c(model_name,pinj_dict_c,qinj_dict_c,0 )# "full"
show(now())
println("")
show("line flow all")
# longitudinal_current_normal(model_name)
# longitudinal_current_contin(model_name)

coupling_constraint(model_name)

(total_cost,cost_gen,cost_pen_lsh,cost_fl,cost_str,cost_pen_ws,cost_pen_lsh_c,cost_pen_ws_c,cost_fl_c,cost_str_c)=objective_SCOPF(model_name)

show(now())
println("")
show("coupling+obj and Optimizer starts ")

optimize!(model_name)
show(now())
println("")
show("optimizer finished")
println("Objective value", JuMP.objective_value(model_name))
println("Solver Time ", JuMP.solve_time(model_name))

empty_contin=0
include("feasible_result.jl")

# (bounded_line_dual_val, bounded_line_dual_val_contin)=dualizing_non_linear()
# ods_write("input_data\\binding_line_flow_$nBus.ods",Dict(("LFlow_normal",1,1)=>[ collect(keys(bounded_line_dual_val)) collect(values(bounded_line_dual_val))]) )
# ods_write("input_data\\binding_line_flow_$nBus.ods",Dict(("LFlow_contin",1,1)=>[ collect(keys(bounded_line_dual_val_contin)) collect(values(bounded_line_dual_val_contin))]) )
# # #
include("AC_SCOPF_Power_Flow.jl")

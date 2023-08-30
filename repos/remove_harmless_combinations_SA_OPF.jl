# load_change_proportion=prof_ploads[1,:]/maximum(prof_ploads[1,:])
# # active_power=[load_change_proportion[t]*rdata_gens[:,2] for t in 1:nTP]
# active_power=zeros(nTP,nGens)
# prof_PRES_tot=sum(prof_PRES; dims=3)
# prof_ploads_tot=sum(prof_ploads; dims=1)
# generation_total=sum(rdata_gens[:,2])
# for t in 1:nTP, j in 1:nGens
#     active_power[t,j]=(Load_MAG*load_change_proportion[t]-(prof_PRES_tot[1,t,1]/prof_ploads_tot[1,t]))*rdata_gens[j,2]
#     # active_power[t,j]=(load_change_proportion[t]*(Load_MAG)-(prof_PRES_tot[1,t,1]/(generation_total)))*rdata_gens[j,2]
# end
# active_power_c=zeros(nCont,nSc,nTP,nGens)
# for c in 1:nCont, s in 1:nSc, t in 1:nTP, j in 1:nGens
#     active_power_c[c,s,t,j]=(Load_MAG*load_change_proportion[t]-(prof_PRES_tot[s,t,1]/prof_ploads_tot[1,t]))*rdata_gens[j,2]
# end
#
# V_avail_c=ones(nCont,nSc, nTP,nBus)
# for c in 1:nCont,s in 1:nSc, t in 1:nTP
# for i in 1:nBus
#     for j in 1:nGens
#         if i==nw_gens[j].gen_bus_num
#             V_avail_c[c,s,t,i]=nw_gens[j].gen_V_set
#
#         end
#     end
# end
# end
#
#  # (input_normal,input_contin,power_flow_normal_result2,power_flow_contin_result2)=power_flow("normal","non_initial", "out_of_MP_PF",0,0,"power_flow_check")
#  # (input_normal,input_contin,power_flow_normal_result2,power_flow_contin_result2)=power_flow("normal","non_initial", "out_of_MP_PF",0,0,0)
#  # (input_normal,input_contin,power_flow_normal_result2,power_flow_contin_result2)=power_flow("all","non_initial", "out_of_MP_PF",0,0,"power_flow_check")
#  (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
#           )=power_flow("all","non_initial", "out_of_MP_PF",0,0,"power_flow_check")
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
# @NLconstraint(model_name, [t=1,l=4],(pinj_dict[[t,idx_from_line[l],idx_to_line[l]]])^2+(qinj_dict[[t,idx_from_line[l],idx_to_line[l]]])^2==0 )
# @NLconstraint(model_name, [t=1,l=4],(pinj_dict[[t,idx_to_line[l],idx_from_line[l]]])^2+(qinj_dict[[t,idx_to_line[l],idx_from_line[l]]])^2==0 )
# @NLconstraint(model_name, [t=1,l=4],(pinj_dict[[t,idx_from_line[l],idx_to_line[l]]])==0 )
# @NLconstraint(model_name, [t=1,l=4],abs(qinj_dict[[t,idx_from_line[l],idx_to_line[l]]])<=0.005 )
# @NLconstraint(model_name, [t=1,l=4],(pinj_dict[[t,idx_to_line[l],idx_from_line[l]]])==0 )
# @NLconstraint(model_name, [t=1,l=4],abs(qinj_dict[[t,idx_to_line[l],idx_from_line[l]]])<=0.005 )
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
          # (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
          #          )=power_flow("contin","non_initial", "out_of_OPF","v_sqr",0,"SA")


           pf_result_perscen_normal      =deepcopy(power_flow_normal_result["pf_result_perscen_normal"])
           branch_flow_check             =deepcopy(power_flow_normal_result["branch_flow_check"])
           voltage_viol_number           =deepcopy(power_flow_normal_result["voltage_viol_number"])
           volt_viol_normal              =deepcopy(power_flow_normal_result["volt_viol_normal"])

           pf_per_dimension              =deepcopy(power_flow_contin_result["pf_per_dimension"])
           branch_flow_check_c           =deepcopy(power_flow_contin_result["branch_flow_check_c"])
           voltage_viol_contin_number    =deepcopy(power_flow_contin_result["voltage_viol_contin_number"])
           volt_viol_contin              =deepcopy(power_flow_contin_result["volt_viol_contin"])


empty_contin=0
   if total_normal_voltage_violation+total_normal_br_violation+total_contin_br_violation+total_contin_voltage_violation==0
       show("No violation found in contingency set. Tractable DC-SCOPF is skipped. ")
       println("")
       empty_contin=1
       # wait()
       # exit=readline()
   end




               (violated_voltage_normal_dic,violated_voltage_contin_dic)=violated_voltage(3,0,0)
               # (first_pf_norm_br_dic,first_pf_contin_br_dic)=highly_loaded_lines(3,0,0)
               (br_viol_nr_dic,br_viol_c_dic)=branch_violation(3,0,0)
               # (br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin)=branch_violation_percent(3,0,0,2,2,0)#branch_violation_percent(indicator_iter,br_viol_perc_dic,br_viol_perc_c_dic,coeff_nr,coeff_c,coeff_compl)
               # (voltage_violation,maximum_volt_violation_nr,maximum_volt_violation_c,total_volt_violation_nr,total_volt_violation_c)=voltage_violation_value(3,2,2,0,0) #voltage_violation_value(indicator_iter,coeff_nr,coeff_c,coeff_compl,voltage_violation)

included_volt_contin=[]
included_volt_scenario=[]
for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
    if haskey(violated_voltage_contin_dic, [c,s,t,b])
        push!(included_volt_contin, c)
        push!(included_volt_scenario, s)
    end

end
included_volt_contin=unique(included_volt_contin)
included_volt_scenario=unique(included_volt_scenario)


include_br_contin=[]
include_br_scenario=[]
for i in 1:length(eachindex(br_viol_c_dic))
    push!(include_br_contin, collect(eachindex(br_viol_c_dic))[i][1])
    push!(include_br_scenario, collect(eachindex(br_viol_c_dic))[i][2])
end
include_br_contin=unique(include_br_contin)
include_br_scenario=unique(include_br_scenario)

included_contingencies=union(included_volt_contin,include_br_contin)
included_scenarios=union(include_br_scenario,include_br_scenario)

idx_c=[]
for c in 1:nCont
    idx_cont=findall3(x->x==c,included_contingencies )
    if !isempty(idx_cont)
    push!(idx_c, idx_cont[1])
end
end

harmless_contin=setdiff(1:nCont, included_contingencies)
if isempty(harmless_contin)
    show("No harmless contingency is detected.")
    println("")
end
harmless_scenario=setdiff(1:nSc, included_scenarios)
if isempty(harmless_scenario)
    show("No harmless scenario is detected.")
    println("")
end


# harmless_contin=setdiff(1:nCont, [1:10;12:25;32:33])
if !isempty(harmless_contin)
from_to_old=zeros(nCont,2)
for c in 1:nCont
    from_to_old[c,1]= array_contin_lines[c].from_contin
    from_to_old[c,2]= array_contin_lines[c].to_contin
end
from_new=deleteat!(from_to_old[:,1],harmless_contin)
to_new  =deleteat!(from_to_old[:,2],harmless_contin)
from_to_new=[from_new to_new]
final_contin_list=[1:length(from_to_new[:,1]) from_to_new]
# included_lines=radiality_filtering(node_data_new)

#----------contingency set definittion--------
header==["cont"; "From"; "To"]
data=final_contin_list
(nCont,
array_contin_lines,
idx_from_line,
idx_to_line,
idx_line,
idx_from_line_c,
idx_to_line_c,
list_of_contingency_lines,
idx_pll_aux,
idx_npll,
data_for_each_contingency)=interface_excel_contingencies(raw_data,header,data)
(idx_from_line,idx_to_line,yij_line,yij_line_sh,idx_from_trans,idx_to_trans,yij_trans,yij_trans_sh,tap_ratio,tap_ratio_min,tap_ratio_max)=f_line_data(array_lines,nw_trans)
(idx_from_line_c,idx_to_line_c,yij_line_c,yij_line_sh_c,line_smax_c)=f_lines_data_contin(data_for_each_contingency)


node_data_contin=f_node_data_contin(nCont,nBus,nw_buses,idx_from_line_c,idx_to_line_c,yij_line_c,yij_line_sh_c,line_smax_c)

end






#  # ================ ACTIVE POWER============
#  Pg_avail=zeros(1,nGens)
#  for i in 1:nGens
#      Pg_avail[1,i]=nw_gens[i].gen_Pg_avl
#      end
#
#  active_generation=zeros(nSc,nTP,nGens)
#  for s in 1:nSc, t in 1:nTP, i in 1:nGens
#  active_generation[s,t,i]=Pg_avail[1,i]
#  end
# # =============== VOLTAGE================
#  V_avail=ones(1,nBus)
#
#  for i in 1:nBus
#      for j in 1:nGens
#          if i==nw_gens[j].gen_bus_num
#              V_avail[1,i]=nw_gens[j].gen_V_set
#
#          end
#      end
#  end
#
#  voltage=zeros(nSc,nTP, nBus)
#  for s in 1:nSc, t in 1:nTP, i in 1:nBus
#      voltage[s,t,i]=V_avail[1,i]
#  end
# voltage_gen=voltage
#
# # =====================POWER FLOW==============
#  (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
#           )=power_flow("all","non_initial", "out_of_PF",0,0,"SA")

# include("OPF_out.jl")

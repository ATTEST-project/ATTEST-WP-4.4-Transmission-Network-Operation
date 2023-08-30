using CPLEX


include("remove_harmless_combinations_SA_OPF.jl")
# println("")
# println("")
# show("WARNING!: The SA tool is skipped!")
# println("")
# println("")
# empty_contin=0
println("")
show("Number  of Contingencies: $nCont")
println("")


 (v0_n,teta0_n)=v_teta_dic_n_state_indep()
 (v0_c,teta0_c)=v_teta_dic_c_state_indep()

function TRACT_SCOPF()
global infeas_flag=0
global tighten_coef=2
global tighten_coef_old=deepcopy(tighten_coef)
global tighten_flag=0
global max_viol_prior=0
global max_viol_current=0
global max_viol_flag=0
global max_viol_counter=0
itermax=11
iteration= 1
tot_viol=100
global max_viol=100
# && (tot_volt_viol==0 & tot_br_viol==0 & tot_volt_vil_c==0 & tot_br_viol_c==0)
while true
if empty_contin==1
    show("Tractable tool skipped!")
    break
end
if iteration>1
    empty!(model_name)
end
show("DC_SCOPF $iteration is started.")
println("")
if iteration==1
@time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",1,0,0,0)
global model_name

elseif iteration==2
    condition_starting_point=[]
    condition_starting_point=isempty(pf_convergence_indicator_n) && isempty(pf_convergence_indicator_c)
    show("$condition_starting_point")
    if condition_starting_point
         @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",2,1,0,0)
         # @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",2,0,0,0)
     else
          @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",2,0,0,0)
   end

# @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",2,0,0,0)
global model_name

elseif iteration>=3 && max_viol_flag==0
@time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",3,1,0,1)
global model_name

end

if  iteration==1 && infeas_flag==1 #|| max_viol<=0.004
    # if  infeas_flag==1
    show("Warning! Infeasible solution")
    break
elseif iteration==2 && infeas_flag==1
    show("Warning! Infeasible solution")
    break
elseif iteration>=3 && infeas_flag==1 || max_viol_flag==1 #&& tighten_infeas_flag==1
    show("Constraint tightening returned an infeasible problem or maximum violation is increased. Relaxation is started.")
    tighten_coef=1
    tighten_flag=1
    infeas_flag=0
    max_viol_counter=max_viol_counter +1
    if iteration==3

           # first_pf_norm_br_dic=br_viol_nr_dic_prior2
           # first_pf_contin_br_dic=first_pf_contin_br_dic_prior2
           # branch_flow_check=branch_flow_check_prior2
           # branch_flow_check_c=branch_flow_check_c_prior2
           power_flow_normal_result=power_flow_normal_result_prior2
           power_flow_contin_result=power_flow_contin_result_prior2
            pf_result_perscen_normal      =deepcopy(power_flow_normal_result["pf_result_perscen_normal"])
            branch_flow_check             =deepcopy(power_flow_normal_result["branch_flow_check"])
            voltage_viol_number           =deepcopy(power_flow_normal_result["voltage_viol_number"])
            volt_viol_normal              =deepcopy(power_flow_normal_result["volt_viol_normal"])

            pf_per_dimension              =deepcopy(power_flow_contin_result["pf_per_dimension"])
            branch_flow_check_c           =deepcopy(power_flow_contin_result["branch_flow_check_c"])
            voltage_viol_contin_number    =deepcopy(power_flow_contin_result["voltage_viol_contin_number"])
            volt_viol_contin              =deepcopy(power_flow_contin_result["volt_viol_contin"])
                (violated_voltage_normal_dic,violated_voltage_contin_dic)=violated_voltage(3,0,0)
                (first_pf_norm_br_dic,first_pf_contin_br_dic)=highly_loaded_lines(3,0,0)

           (br_viol_nr_dic,br_viol_c_dic)=branch_violation(3,0,0)
           (br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin)=branch_violation_percent(3,0,0,tighten_coef,tighten_coef,0,tighten_flag)#branch_violation_percent(indicator_iter,br_viol_perc_dic,br_viol_perc_c_dic,coeff_nr,coeff_c,coeff_compl)
           (voltage_violation,maximum_volt_violation_nr,maximum_volt_violation_c,total_volt_violation_nr,total_volt_violation_c)=voltage_violation_value(3,tighten_coef,tighten_coef,0,0,tighten_flag) #voltage_violation_value(indicator_iter,coeff_nr,coeff_c,coeff_compl,voltage_violation)
global            max_viol=maximum([maximum_br_violation_normal,maximum_br_violation_contin,maximum_volt_violation_nr[1][2],maximum_volt_violation_c[1][2]])
            empty!(model_name)
            @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",3,1,0,1)


           if infeas_flag==1
               show("Tightening relaxation returned infeasibility and the most recent feasible result is reported.")
               break
           elseif infeas_flag==0
               tighten_flag=0
               tighten_coef=2

           end
    elseif iteration>=4
           (br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin)=branch_violation_percent(4,br_viol_perc_dic,br_viol_perc_c_dic,tighten_coef,tighten_coef,tighten_coef,tighten_flag)
           (voltage_violation,maximum_volt_violation_nr,maximum_volt_violation_c,total_volt_violation_nr,total_volt_violation_c)=voltage_violation_value(4,tighten_coef,tighten_coef,tighten_coef,voltage_violation,tighten_flag)  #voltage_violation_value(indicator_iter,coeff_nr,coeff_c,voltage_violation)
           max_viol=maximum([maximum_br_violation_normal,maximum_br_violation_contin,maximum_volt_violation_nr[1][2],maximum_volt_violation_c[1][2]])

           empty!(model_name)
           @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",3,1,0,1)
          # WARNING! It is possible that large number of highly loaded lines, found in the previous PF, lead infeasibility even if the tightening constraints are relaxed.
           if infeas_flag==1
               show("Tightening relaxation returned infeasibility and the most recent feasible result is reported.")
               break
           elseif infeas_flag==0
               tighten_flag=0
               tighten_coef=2
           end
       end

end

include("feasible_result.jl")


show("Power flow $iteration is started.")
println("")
@time  (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
         )=power_flow("all","non_initial", "out_of_OPF","v_sqr","v_sqr","contin")
global pf_result_perscen_normal      =deepcopy(power_flow_normal_result["pf_result_perscen_normal"])
global branch_flow_check             =deepcopy(power_flow_normal_result["branch_flow_check"])
global voltage_viol_number           =deepcopy(power_flow_normal_result["voltage_viol_number"])
global volt_viol_normal              =deepcopy(power_flow_normal_result["volt_viol_normal"])
global pf_convergence_indicator_n     =deepcopy(power_flow_normal_result["convergence"])



global pf_per_dimension              =deepcopy(power_flow_contin_result["pf_per_dimension"])
global branch_flow_check_c           =deepcopy(power_flow_contin_result["branch_flow_check_c"])
global voltage_viol_contin_number    =deepcopy(power_flow_contin_result["voltage_viol_contin_number"])
global volt_viol_contin              =deepcopy(power_flow_contin_result["volt_viol_contin"])
global pf_convergence_indicator_c     =deepcopy(power_flow_contin_result["convergence"])



tot_viol=total_normal_voltage_violation+total_normal_br_violation+total_contin_voltage_violation+total_contin_br_violation
if tot_viol==0
    break
end
show("End of iteration $iteration")
println("")
if iteration==1 && (isempty(pf_convergence_indicator_n) && isempty(pf_convergence_indicator_c))

    global    (v0_n,teta0_n)=pf_v_teta_dic_n()
    global    (v0_c,teta0_c)=pf_v_teta_dic_c(1)
     degree=90
     for i in eachindex(teta0_n)
        if teta0_n[i]>=deg2rad(degree)
           push!(teta0_n, i=>deg2rad(degree))
        elseif teta0_n[i]<deg2rad(-degree)
        push!(teta0_n, i=>deg2rad(-degree))
        end
    end
for i in eachindex(teta0_c)
    if teta0_c[i]>=deg2rad(degree)
        push!(teta0_c, i=>deg2rad(degree))
    elseif teta0_c[i]<deg2rad(-degree)
        push!(teta0_c, i=>deg2rad(-degree))
    end
end
for i in eachindex(v0_n)
    if v0_n[i]>=nw_buses[1].bus_vmax
        push!(v0_n, i=>nw_buses[1].bus_vmax)
    elseif v0_n[i]<nw_buses[1].bus_vmin
        push!(v0_n, i=>nw_buses[1].bus_vmin)
    end
end
    for i in eachindex(v0_c)
        if v0_c[i]>=nw_buses[1].bus_vmax+v_relax_factor_min
            push!(v0_c, i=>nw_buses[1].bus_vmax+v_relax_factor_min)
        elseif v0_c[i]<nw_buses[1].bus_vmin-v_relax_factor_min
            push!(v0_c, i=>nw_buses[1].bus_vmin-v_relax_factor_min)
        end
    end


# return v0_n,teta0_n,v0_c,teta0_c
# global max_viol=maximum([maximum_br_violation_normal,maximum_br_violation_contin,maximum_volt_violation_nr[1][2],maximum_volt_violation_c[1][2]])
# show(max_viol)

elseif iteration==2

if !condition_starting_point
    show("$condition_starting_point")
    global    (v0_n,teta0_n)=pf_v_teta_dic_n()
    global    (v0_c,teta0_c)=pf_v_teta_dic_c(1)
     degree=90
     for i in eachindex(teta0_n)
        if teta0_n[i]>=deg2rad(degree)
           push!(teta0_n, i=>deg2rad(degree))
        elseif teta0_n[i]<deg2rad(-degree)
        push!(teta0_n, i=>deg2rad(-degree))
        end
    end
for i in eachindex(teta0_c)
    if teta0_c[i]>=deg2rad(degree)
        push!(teta0_c, i=>deg2rad(degree))
    elseif teta0_c[i]<deg2rad(-degree)
        push!(teta0_c, i=>deg2rad(-degree))
    end
end
for i in eachindex(v0_n)
    if v0_n[i]>=nw_buses[1].bus_vmax
        push!(v0_n, i=>nw_buses[1].bus_vmax)
    elseif v0_n[i]<nw_buses[1].bus_vmin
        push!(v0_n, i=>nw_buses[1].bus_vmin)
    end
end
    for i in eachindex(v0_c)
        if v0_c[i]>=nw_buses[1].bus_vmax+v_relax_factor_min
            push!(v0_c, i=>nw_buses[1].bus_vmax+v_relax_factor_min)
        elseif v0_c[i]<nw_buses[1].bus_vmin-v_relax_factor_min
            push!(v0_c, i=>nw_buses[1].bus_vmin-v_relax_factor_min)
        end
    end
end

global    (violated_voltage_normal_dic,violated_voltage_contin_dic)=violated_voltage(3,0,0)
global    (first_pf_norm_br_dic,first_pf_contin_br_dic)=highly_loaded_lines(3,0,0)
global    (br_viol_nr_dic,br_viol_c_dic)=branch_violation(3,0,0)
global    (br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin)=branch_violation_percent(3,0,0,tighten_coef,tighten_coef,0,tighten_flag)#branch_violation_percent(indicator_iter,br_viol_perc_dic,br_viol_perc_c_dic,coeff_nr,coeff_c,coeff_compl)
global    (voltage_violation,maximum_volt_violation_nr,maximum_volt_violation_c,total_volt_violation_nr,total_volt_violation_c)=voltage_violation_value(3,tighten_coef,tighten_coef,0,0,tighten_flag) #voltage_violation_value(indicator_iter,coeff_nr,coeff_c,coeff_compl,voltage_violation)

global max_viol=maximum([maximum_br_violation_normal,maximum_br_violation_contin,maximum_volt_violation_nr[1][2],maximum_volt_violation_c[1][2]])
# global           br_viol_nr_dic_prior2=deepcopy(first_pf_norm_br_dic)
# global           first_pf_contin_br_dic_prior2=deepcopy(first_pf_contin_br_dic)
# global           branch_flow_check_prior2 =deepcopy(branch_flow_check)
# global           branch_flow_check_c_prior2 =deepcopy(branch_flow_check_c)
global          power_flow_normal_result_prior2=deepcopy(power_flow_normal_result)
global          power_flow_contin_result_prior2=deepcopy(power_flow_contin_result)
show(max_viol)
elseif iteration>=3
     max_viol_prior=deepcopy(max_viol)
     show(max_viol_prior)
     println("")
    (violated_voltage_normal_dic,violated_voltage_contin_dic)=violated_voltage(4,violated_voltage_normal_dic,violated_voltage_contin_dic)
    (first_pf_norm_br_dic,first_pf_contin_br_dic)=highly_loaded_lines(4,first_pf_norm_br_dic,first_pf_contin_br_dic)
    (br_viol_nr_dic,br_viol_c_dic)=branch_violation(4,br_viol_nr_dic,br_viol_c_dic)
    (br_viol_perc_dic,br_viol_perc_c_dic,maximum_br_violation_normal,maximum_br_violation_contin,total_br_violation_normal,total_br_violation_contin)=branch_violation_percent(4,br_viol_perc_dic,br_viol_perc_c_dic,tighten_coef,tighten_coef,tighten_coef,tighten_flag)
    (voltage_violation,maximum_volt_violation_nr,maximum_volt_violation_c,total_volt_violation_nr,total_volt_violation_c)=voltage_violation_value(4,tighten_coef,tighten_coef,tighten_coef,voltage_violation,tighten_flag)  #voltage_violation_value(indicator_iter,coeff_nr,coeff_c,voltage_violation)
    max_viol=maximum([maximum_br_violation_normal,maximum_br_violation_contin,maximum_volt_violation_nr[1][2],maximum_volt_violation_c[1][2]])
    max_viol_current=deepcopy(max_viol)
    show(max_viol_current)
end

println("")
if  iteration> itermax || tot_viol==0  || max_viol<=0.009 || max_viol_counter>=3 || (iteration==2 && !(isempty(pf_convergence_indicator_n) && isempty(pf_convergence_indicator_c)))
    # if  infeas_flag==1
    show("Stop at iteration: $iteration")
    println("")
    show("Number of total violation is : $tot_viol")
    println("")
    show("Maximum violation is : $max_viol")
break
end
# if tighten_flag==2
#     println("")
#     show("Tightening relaxation stop iterations.")
#     break
# end
if max_viol_current>max_viol_prior
  show("Maximum violation is increased. Relaxation is started")
  max_viol_flag=1
  iteration-=1
end

 iteration+= 1
end
 return iteration
end



iteration=TRACT_SCOPF()

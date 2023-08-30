println("")
println("Power Flow tool can solve the power flow for the results from OPF, SCOPF, or an initial point")
println("")
println(" For PF out of initial point(only nTP=1 hour)=========>type =0")
println(" For PF out of Stochastic Multi-period OPF============>type =1")
println(" For PF out of Stochastic Multi-periodSCOPF===========>type =2")
pf_problem = readline()
pf_problem = parse(Int64, pf_problem)
println("The selected problem is:")
if      pf_problem==0
    show("PF out of initial point")
elseif pf_problem==1
    show("PF out of Stochastic Multi-period OPF")
elseif pf_problem==2
    show("PF out of Stochastic Multi-period SCOPF")
end

#
if      pf_problem==0
    include("load_EV_PV.jl")

    include("functions/PF_functions_common.jl")
    include("functions/PF_functions_n.jl")

    (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
            )=power_flow("normal","non_initial", "out_of_PF",0,0,0)
            # power_flow("normal/contin/all","initial/non_initial", "out_of_PF/out_of_OPF",0 if out of Pf and v_sqr/v_pol if out of opf,0 if out of SA and v_sqr/v_pol if out of contin, "contin/SA")

elseif pf_problem==1
    # if the voltage is rectangular use the following function to make it polar and the power flow will do the sqrt()
    # (v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c)=rect_to_polar("normal")
    (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
            )=power_flow("normal","non_initial", "out_of_OPF","v_sqr",0,0)
    # power_flow("normal/contin/all","initial/non_initial", "out_of_PF/out_of_OPF",0 if out of Pf and v_sqr/v_pol if out of opf,0 if out of SA and v_sqr/v_pol if out of contin, "contin/SA")
elseif pf_problem==2
    # if the voltage is rectangular use the following function to make it polar and the power flow will do the sqrt()
    # (v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c)=rect_to_polar("contin")
    (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
            )=power_flow("all","non_initial", "out_of_OPF","v_sqr","v_sqr","contin")
end

(v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c)=rect_to_polar("contin")
# # #
v_gen=[voltage_gen[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]
v_ang=[volt_ang[i] for i in 1:nBus if ~isempty(findall(x->x==i, bus_data_gsheet))]
# # #
# # # ods_write("input_data\\SA_results_$nBus.ods",Dict(("PF",1,1)=>[value.(Pg[1,1,:]) value.(Qg[1,1,:]) v_gen v_ang]) )
# # #
#
# (input_normal,input_contin,power_flow_normal_result2,power_flow_contin_result2)=power_flow("all","non_initial", "out_of_OPF","v_sqr","v_sqr","contin")
# power_flow("normal/contin/all","initial/non_initial", "out_of_PF/out_of_OPF",0 if out of Pf and v_sqr/v_pol if out of opf,0 if out of SA and v_sqr/v_pol if out of contin, "contin/SA")



(input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
         )=power_flow("all","non_initial", "out_of_OPF","v_sqr","v_sqr","contin")

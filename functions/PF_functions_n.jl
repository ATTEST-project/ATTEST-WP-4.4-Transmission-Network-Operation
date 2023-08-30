function PF_input_normal(initialization, indicator,v_indic)
    nw_lines_pf=initialization["nw_lines_pf"]
    # nw_loads_pf=initialization["nw_loads_pf"]
    nw_gens_pf=initialization["nw_gens_pf"]
    nw_sbase_pf=initialization["nw_sbase_pf"]
    v_initial_pf=initialization["v_initial_pf"]
    epsilon=initialization["epsilon"]
    epsilon_suf=initialization["epsilon_suf"]
    iteration=initialization["iteration"]
    itr_max=initialization["itr_max"]
    maxiter=initialization["maxiter"]
    load_bus_type=initialization["load_bus_type"]
    vol_ctrl_bus_type=initialization["vol_ctrl_bus_type"]
    slack_bus_type=initialization["slack_bus_type"]
    v_sp_pf=initialization["v_sp_pf"]
    node_vol_pf=initialization["node_vol_pf"]
    v_angle_pf=initialization["v_angle_pf"]


    if indicator=="out_of_PF"  #to input variables from an optimization or a saved PF result
    # p_scheduled_normal=JuMP.value.(Pg[:,:])
    q_scheduled_normal=zeros(nTP,nGens)
    Pg_avail=zeros(1,nGens)
    for i in 1:nGens
        Pg_avail[1,i]=nw_gens[i].gen_Pg_avl
        end

    V_avail=ones(1,nBus)

    for i in 1:nBus
        for j in 1:nGens
            if i==nw_gens[j].gen_bus_num
                V_avail[1,i]=nw_gens[j].gen_V_set

            end
        end
    end

    p_scheduled_normal=Pg_avail
    # q_scheduled_normal=zeros(1,1,nGens)
    v_mag_total       =V_avail

    # v_mag_total       =JuMP.value.(v_sq[:,:,:]).^0.5
    # v_mag_total        =voltage_gen


    shunt=[]
    if ~isempty(nw_shunts)
        dim=(length(1:nTP),length(1:nShnt))
        shunt_elem = zeros(Float64,dim)
        for t in 1:nTP
        shunt_elem[t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
         end

        push!(shunt,shunt_elem)
    elseif isempty(nw_shunts)
        push!(shunt, zeros(nTP,1))
    end
    nd_shunt          =shunt[1]
    # if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
    nd_ren_curt       =zeros(nTP,nRES)
    nd_load_curt      =zeros(nTP,nLoads)
    p_flex_inc          =zeros(nTP,nFl)
    p_flex_dec          =zeros(nTP,nFl)
    p_chrg              =zeros(nTP,nStr_active)
    p_dis_ch             =zeros(nTP,nStr_active)

input_normal=Dict(
"p_scheduled_normal"=>p_scheduled_normal,
"q_scheduled_normal"=>q_scheduled_normal,
"v_mag_total"=>v_mag_total,
"nd_shunt"=>nd_shunt,
"nd_ren_curt"=>nd_ren_curt,
"nd_load_curt"=>nd_load_curt,
"p_flex_inc"=>p_flex_inc,
"p_flex_dec"=>p_flex_dec,
"p_chrg"=>p_chrg,
"p_dis_ch"=>p_dis_ch

)

    return  input_normal
elseif indicator=="out_of_MP_PF"  #to input variables from an optimization or a saved PF result
    # p_scheduled_normal=JuMP.value.(Pg[:,:])
    q_scheduled_normal=zeros(nTP,nGens)
    # Pg_avail=active_power
    # for i in 1:nGens
    #     Pg_avail[1,i]=nw_gens[i].gen_Pg_avl
    #     end

    V_avail=ones(nTP,nBus)
for t in 1:nTP
    for i in 1:nBus
        for j in 1:nGens
            if i==nw_gens[j].gen_bus_num
                V_avail[t,i]=nw_gens[j].gen_V_set

            end
        end
    end
end
    p_scheduled_normal=active_power
    # q_scheduled_normal=zeros(1,1,nGens)
    v_mag_total       =V_avail

    # v_mag_total       =JuMP.value.(v_sq[:,:,:]).^0.5
    # v_mag_total        =voltage_gen


    shunt=[]
    if ~isempty(nw_shunts)
        dim=(length(1:nTP),length(1:nShnt))
        shunt_elem = zeros(Float64,dim)
        for t in 1:nTP
        shunt_elem[t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
         end

        push!(shunt,shunt_elem)
    elseif isempty(nw_shunts)
        push!(shunt, zeros(nTP,1))
    end
    nd_shunt          =shunt[1]
    # if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
    nd_ren_curt       =zeros(nTP,nRES)
    nd_load_curt      =zeros(nTP,nLoads)
    p_flex_inc          =zeros(nTP,nFl)
    p_flex_dec          =zeros(nTP,nFl)
    p_chrg              =zeros(nTP,nStr_active)
    p_dis_ch             =zeros(nTP,nStr_active)

input_normal=Dict(
"p_scheduled_normal"=>p_scheduled_normal,
"q_scheduled_normal"=>q_scheduled_normal,
"v_mag_total"=>v_mag_total,
"nd_shunt"=>nd_shunt,
"nd_ren_curt"=>nd_ren_curt,
"nd_load_curt"=>nd_load_curt,
"p_flex_inc"=>p_flex_inc,
"p_flex_dec"=>p_flex_dec,
"p_chrg"=>p_chrg,
"p_dis_ch"=>p_dis_ch

)

    return  input_normal
elseif indicator=="out_of_OPF"
    p_scheduled_normal=JuMP.value.(Pg[:,:])
    q_scheduled_normal=zeros(nTP,nGens)
    # Pg_avail=zeros(1,nGens)
    # for i in 1:nGens
    #     Pg_avail[1,i]=nw_gens[i].gen_Pg_avl
    #     end
    #
    # V_avail=ones(1,nBus)
    #
    # for i in 1:nBus
    #     for j in 1:nGens
    #         if i==nw_gens[j].gen_bus_num
    #             V_avail[1,i]=nw_gens[j].gen_V_set
    #
    #         end
    #     end
    # end
    #
    # p_scheduled_normal=Pg_avail
    # q_scheduled_normal=zeros(1,nGens)
    # v_mag_total       =V_avail

    # v_mag_total       =JuMP.value.(v_sq[:,:]).^0.5
    # v_mag_total        =voltage_gen
    v_mag_total=zeros(nTP,nBus)
    if v_indic=="v_sqr"
     v_mag_total        =JuMP.value.(v_sq[:,:]).^0.5
 elseif v_indic=="v_pol"
     v_mag_total        =voltage_gen
 end

    shunt=[]
    if ~isempty(nw_shunts)
        dim=(length(1:nTP),length(1:nShnt))
        shunt_elem = zeros(Float64,dim)
        for t in 1:nTP
        shunt_elem[t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
         end

        push!(shunt,shunt_elem)
    elseif isempty(nw_shunts)
        push!(shunt, zeros(nTP,1))
    end
    nd_shunt          =shunt[1]
    # if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
    if !isnothing(variable_by_name(model_name, "pen_ws[1,1]"))
        nd_ren_curt       =JuMP.value.(pen_ws[:,:])
    else
        nd_ren_curt       =zeros(nTP,nRES)
    end
    if !isnothing(variable_by_name(model_name, "pen_lsh[1,1]"))
        nd_load_curt  =JuMP.value.(pen_lsh[:,:])
    else
        nd_load_curt   =zeros(nTP,nLoads)
    end

    if !isnothing(variable_by_name(model_name, "p_fl_inc[1,1]"))
        p_flex_inc   =JuMP.value.(p_fl_inc[:,:])
    else
        p_flex_inc  =zeros(nTP,nFl)
    end

    if !isnothing(variable_by_name(model_name, "p_fl_dec[1,1]"))
        p_flex_dec   =JuMP.value.(p_fl_dec[:,:])
    else
        p_flex_dec   =zeros(nTP,nFl)
    end
    if !isnothing(variable_by_name(model_name, "p_ch[1,1]"))
        p_chrg   =JuMP.value.(p_ch[:,:])
    else
        p_chrg  =zeros(nTP,nStr_active)
    end
    if !isnothing(variable_by_name(model_name, "p_dis[1,1]"))
        p_dis_ch   =JuMP.value.(p_dis[:,:])
    else
        p_dis_ch  =zeros(nTP,nStr_active)
    end

    input_normal=Dict(
    "p_scheduled_normal"=>p_scheduled_normal,
    "q_scheduled_normal"=>q_scheduled_normal,
    "v_mag_total"=>v_mag_total,
    "nd_shunt"=>nd_shunt,
    "nd_ren_curt"=>nd_ren_curt,
    "nd_load_curt"=>nd_load_curt,
    "p_flex_inc"=>p_flex_inc,
    "p_flex_dec"=>p_flex_dec,
    "p_chrg"=>p_chrg,
    "p_dis_ch"=>p_dis_ch

    )

        return  input_normal
end

end

function loop_free(initialization)
    nw_lines_pf=initialization["nw_lines_pf"]
    # nw_loads_pf=initialization["nw_loads_pf"]
    nw_gens_pf=initialization["nw_gens_pf"]
    nw_sbase_pf=initialization["nw_sbase_pf"]
    v_initial_pf=initialization["v_initial_pf"]
    epsilon=initialization["epsilon"]
    epsilon_suf=initialization["epsilon_suf"]
    iteration=initialization["iteration"]
    itr_max=initialization["itr_max"]
    maxiter=initialization["maxiter"]
    load_bus_type=initialization["load_bus_type"]
    vol_ctrl_bus_type=initialization["vol_ctrl_bus_type"]
    slack_bus_type=initialization["slack_bus_type"]
    v_sp_pf=initialization["v_sp_pf"]
    node_vol_pf=initialization["node_vol_pf"]
    v_angle_pf=initialization["v_angle_pf"]
    rdata_buses[:,2]=deepcopy([nw_buses[i].bus_type for i in 1:nBus])

idx_slack_bus_pf = findall3(x->x==slack_bus_type,rdata_buses[:,2])
idx_PV_buses_pf  = findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2])
idx_PQ_buses_pf  = findall3(x->x==load_bus_type,rdata_buses[:,2])

idx_oPV_buses_pf = findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2])

num_slack_bus_pf = length(idx_slack_bus_pf)
num_PQ_buses_pf  = length(idx_PQ_buses_pf)
num_PV_buses_pf  = length(idx_PV_buses_pf)
old_num_PV_buses_pf = num_PV_buses_pf
new_num_PV_buses_pf = num_PV_buses_pf

idx_cmb_pf = vcat(idx_slack_bus_pf,idx_PV_buses_pf)

J11 = zeros(size(rdata_buses,1)-num_slack_bus_pf,size(rdata_buses,1)-num_slack_bus_pf)
J12 = zeros(size(rdata_buses,1)-num_slack_bus_pf,size(rdata_buses,1)-num_slack_bus_pf)
J21 = zeros(size(rdata_buses,1)-num_slack_bus_pf,size(rdata_buses,1)-num_slack_bus_pf)
J22 = zeros(size(rdata_buses,1)-num_slack_bus_pf,size(rdata_buses,1)-num_slack_bus_pf)

## ---------------- Formation of Admittance matrix -----------------------------
# y_bus = Y_bus(nw_lines_pf,nw_buses_pf)
y_bus = Y_bus(nBus, node_data,node_data_trans,
# optim_tratio_normal,
nw_trans,rdata_transformers)

p_sch_pf   = zeros(size(rdata_buses,1)-num_slack_bus_pf)                              # Net schedule active power except slack bus
q_sch_pf   = zeros(size(rdata_buses,1)-num_slack_bus_pf)                              # Net schedule reactive power except slack bus
p_node_pf  = zeros(size(rdata_buses,1)-num_slack_bus_pf)                              # Injected active power vector (dimension is one less than the number of nodes; excludes slack bus)                                    # Injected active power
q_node_pf  = zeros(size(rdata_buses,1)-num_slack_bus_pf)                              # Injected reactive power vector (dimension is one less than the number of nodes; excludes slack bus)


return idx_slack_bus_pf,
idx_PV_buses_pf  ,
idx_PQ_buses_pf  ,
idx_oPV_buses_pf ,
num_slack_bus_pf ,
num_PQ_buses_pf  ,
num_PV_buses_pf  ,
old_num_PV_buses_pf ,
new_num_PV_buses_pf ,
idx_cmb_pf ,
J11 ,
J12 ,
J21 ,
J22 ,
y_bus ,
p_sch_pf  ,
q_sch_pf   ,
p_node_pf ,
q_node_pf

end

function run_PF_normal(initialization,input_normal,indicator)
    nw_lines_pf=initialization["nw_lines_pf"]
    # nw_loads_pf=initialization["nw_loads_pf"]
    nw_gens_pf=initialization["nw_gens_pf"]
    nw_sbase_pf=initialization["nw_sbase_pf"]
    v_initial_pf=initialization["v_initial_pf"]
    epsilon=initialization["epsilon"]
    epsilon_suf=initialization["epsilon_suf"]
    iteration=initialization["iteration"]
    itr_max=initialization["itr_max"]
    maxiter=initialization["maxiter"]
    load_bus_type=initialization["load_bus_type"]
    vol_ctrl_bus_type=initialization["vol_ctrl_bus_type"]
    slack_bus_type=initialization["slack_bus_type"]
    v_sp_pf=initialization["v_sp_pf"]
    node_vol_pf=initialization["node_vol_pf"]
    v_angle_pf=initialization["v_angle_pf"]

    p_scheduled_normal=input_normal["p_scheduled_normal"]
    q_scheduled_normal=input_normal["q_scheduled_normal"]
    v_mag_total=input_normal["v_mag_total"]
    nd_shunt=input_normal["nd_shunt"]
    nd_ren_curt=input_normal["nd_ren_curt"]
    nd_load_curt=input_normal["nd_load_curt"]
    p_flex_inc=input_normal["p_flex_inc"]
    p_flex_dec=input_normal["p_flex_dec"]
    p_chrg=input_normal["p_chrg"]
    p_dis_ch=input_normal["p_dis_ch"]
all_results=[]
all_results=Dict{Int64,Dict{Symbol,Any}}()
pf_result_normal=[]
idx_converge_normal=[]

(idx_slack_bus_pf,
idx_PV_buses_pf  ,
idx_PQ_buses_pf  ,
idx_oPV_buses_pf ,
num_slack_bus_pf ,
num_PQ_buses_pf  ,
num_PV_buses_pf  ,
old_num_PV_buses_pf ,
new_num_PV_buses_pf ,
idx_cmb_pf ,
J11 ,
J12 ,
J21 ,
J22 ,
y_bus ,
p_sch_pf  ,
q_sch_pf   ,
p_node_pf ,
q_node_pf  )=loop_free(initialization)
if indicator=="non_initial"
for   t in 1:nTP
    rdata_buses[:,2]=deepcopy([nw_buses[i].bus_type for i in 1:nBus])
    ordata_buses_pf =deepcopy([nw_buses[i].bus_type for i in 1:nBus])
active_gen  =p_scheduled_normal[t,:]
reactive_gen=q_scheduled_normal[t,:]
nd_shunt_vec=nd_shunt[t,:]
nd_ren_curt_vec=nd_ren_curt[t,:]
nd_load_curt_vec=nd_load_curt[t,:]
nw_pPrf=prof_ploads[:,t]
nw_qPrf=prof_qloads[:,t]
prof_PRES_vec=prof_PRES[1,t,:]
p_fl_inc_vec=p_flex_inc[t,:]
p_fl_dec_vec=p_flex_dec[t,:]
p_ch_vec    =p_chrg[t,:]
p_dis_vec   =p_dis_ch[t,:]
v_mag_pf=v_mag_total[t,:]

(vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator)=ac_power_flow_model(initialization,slack_bus_type,vol_ctrl_bus_type,load_bus_type,
nBus,rdata_buses,
nw_gens_pf,
v_mag_pf,v_angle_pf,
node_data,node_data_trans,
# optim_tratio_normal,
nw_trans,rdata_transformers,
nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
active_gen,reactive_gen,
# p_sch_pf,q_sch_pf,
# nw_sbase,
nd_load_curt_vec,
nd_ren_curt_vec,
nd_shunt_vec,
p_fl_inc_vec,
p_fl_dec_vec,
p_ch_vec,
p_dis_vec,
epsilon,iteration,itr_max,
old_num_PV_buses_pf,
p_sch_pf,
q_sch_pf,
p_node_pf,
q_node_pf,
y_bus,
idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
J11,J12,J21,J22,
num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
t
)

# push!(all_results, vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf)
all_results_per_time=Dict(:v_mag=>vol_nodes_mag_pf,
                :v_ang=>vol_nodes_theta_pf,
                :p_cal=>p_node_pf_calc_pf,
                :q_cal=>q_node_pf_calc_pf,
                :p_sch=>p_schedule_node_pf,
                :q_sch=>q_schedule_node_pf)
                push!(all_results,t=>all_results_per_time)

push!(pf_result_normal,(vol_nodes_mag_pf,vol_nodes_theta_pf,p_schedule_node_pf,q_schedule_node_pf))
push!(idx_converge_normal, convergence_indicator)

end

idx_conv_normal=[]
for c in 1:nCont
    idx_con=findall3(x->x==0, idx_converge_normal )
    if ~isempty(idx_con)
    push!(idx_conv_normal,idx_con)
end
end

if isempty(idx_conv_normal)
    println("")
    # show("$idx_conv_normal")
    show("The power flow has converged successfully for all normal cases")
    println("")
else
    println("")
    # show("$idx_conv_normal")
    show("WARNING! The power flow has NOT converged for some normal cases")
    println("")
end

pf_result_perscen_normal=[]
# for s in 1:nSc
    for s in 1
    # push!(node_data_contin, node_data_c[i+(nLines-2)*(i-1):i+(nLines-2)*(i-1)+(nLines-2)])
    push!(pf_result_perscen_normal, pf_result_normal[s+(nTP-1)*(s-1):s*nTP])
    # push!(pf_result_perscen_normal, pf_result_normal)
end



# pf_result_perscen_normal[10][24][1] is v_mag  and  pf_result_perscen_normal[10][24][2] is v_angle

# violated_voltage_normal=[]
relaxation_f=0.003
min_violation=[]
max_violation=[]
voltage_viol_number=[]
volt_viol_normal=Dict{Array{Int64,1},Float64}()
for  s in 1, t in 1:nTP, b in 1:nBus
violated_voltage_nr=findall(x->x>(nw_buses[b].bus_vmax)+relaxation_f || x<(nw_buses[b].bus_vmin)-relaxation_f, pf_result_perscen_normal[s][t][1][b])
if ~isempty(violated_voltage_nr)
#     println("NO vlotage violation")
# else
    # push!(violated_voltage_normal,[s,t,violated_voltage_nr])
    # push!(min_violation,minimum(pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr))
    # push!(max_violation,maximum(pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr))
    # push!(violation_value,[pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr])
    push!(voltage_viol_number,1)
    push!(volt_viol_normal, [t,b]=>pf_result_perscen_normal[s][t][1][b])
    # println("WARNING! vlotage violation in Scen $s, Time $t Bus $b ")
end
end


branch_flow_check=[line_flow_violation(yij_line,yij_line_sh,idx_from_line,idx_to_line,pf_result_perscen_normal[s][t][1],pf_result_perscen_normal[s][t][2],nw_lines,s,t) for  s in 1, t in 1:nTP]
# branch_flow_check[10,24][1] returns the Sij for all lines and branch_flow_check[10,24][2] returns the violated lines index and branch_flow_check[10,24][3] returns the violated percentage and branch_flow_check[10,24][4] counts the lines loaded over than 80%
# branch_flow_check[10,24][3][1] returns the elements in the array
# violated_q_n=[]
# #
# for s=1:nSc,t=1:nTP,i in 1:nGens
#     idx_reactive_violation=findall(x->x>qg_max[i]+epsilon_suf || x<qg_min[i]- epsilon_suf, pf_result_perscen_normal[s][t][4][i])
#       if ~isempty(idx_reactive_violation)
#           push!(violated_q_n,i)
#          println("Reactive power violation in gen: $i ")
#       # else
#       #     println("No reactive power violation in normal op.")
#       end
#
#   end
# if isempty(violated_q_n)
#      println("No reactive power violation in normal op.")
# end
power_flow_normal_result=Dict(
"all_results"=>all_results,
"pf_result_perscen_normal"=>pf_result_perscen_normal,
"branch_flow_check"=>branch_flow_check,
"voltage_viol_number"=>voltage_viol_number,
"volt_viol_normal"=>volt_viol_normal,
"convergence"    => idx_conv_normal
)
return power_flow_normal_result
elseif indicator=="initial"
    for   t in 1:nTP

        rdata_buses[:,2]=deepcopy([nw_buses[i].bus_type for i in 1:nBus])
        ordata_buses_pf =deepcopy([nw_buses[i].bus_type for i in 1:nBus])
    active_gen  =p_scheduled_normal[1,:]
    reactive_gen=q_scheduled_normal[1,:]
    nd_shunt_vec=nd_shunt[1,:]
    nd_ren_curt_vec=nd_ren_curt[1,:]
    nd_load_curt_vec=nd_load_curt[1,:]
    nw_pPrf=prof_ploads[:,1]
    nw_qPrf=prof_qloads[:,1]
    prof_PRES_vec=prof_PRES[1,1,:]
    p_fl_inc_vec=p_flex_inc[1,:]
    p_fl_dec_vec=p_flex_dec[1,:]
    p_ch_vec    =p_chrg[1,:]
    p_dis_vec   =p_dis_ch[1,:]
    v_mag_pf=v_mag_total[1,:]

    (vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator)=ac_power_flow_model(initialization,slack_bus_type,vol_ctrl_bus_type,load_bus_type,
    nBus,rdata_buses,
    nw_gens_pf,
    v_mag_pf,v_angle_pf,
    node_data,node_data_trans,
    # optim_tratio_normal,
    nw_trans,rdata_transformers,
    nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
    active_gen,reactive_gen,
    # p_sch_pf,q_sch_pf,
    # nw_sbase,
    nd_load_curt_vec,
    nd_ren_curt_vec,
    nd_shunt_vec,
    p_fl_inc_vec,
    p_fl_dec_vec,
    p_ch_vec,
    p_dis_vec,
    epsilon,iteration,itr_max,
    old_num_PV_buses_pf,
    p_sch_pf,
    q_sch_pf,
    p_node_pf,
    q_node_pf,
    y_bus,
    idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
    J11,J12,J21,J22,
    num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
    t
    )

    # push!(all_results, vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf)
    all_results_per_time=Dict(:v_mag=>vol_nodes_mag_pf,
                    :v_ang=>vol_nodes_theta_pf,
                    :p_cal=>p_node_pf_calc_pf,
                    :q_cal=>q_node_pf_calc_pf,
                    :p_sch=>p_schedule_node_pf,
                    :q_sch=>q_schedule_node_pf)
                    push!(all_results,t=>all_results_per_time)

    push!(pf_result_normal,(vol_nodes_mag_pf,vol_nodes_theta_pf,p_schedule_node_pf,q_schedule_node_pf))
    push!(idx_converge_normal, convergence_indicator)

    end

    idx_conv_normal=[]
    for c in 1:nCont
        idx_con=indexin(0, idx_converge_normal )
        if ~isnothing(idx_con[1])
        push!(idx_conv_normal,idx_con)
    end
    end

    if isempty(idx_conv_normal)
        println("")
        show("The power flow has converged successfully for all noraml cases")
        println("")
    else
        println("")
        show("WARNING! The power flow has NOT converged successfully for some normal cases")
        println("")
    end

    pf_result_perscen_normal=[]
    # nSC=1
    # nTP=1
    for s in 1
    # nTP=1
        # push!(node_data_contin, node_data_c[i+(nLines-2)*(i-1):i+(nLines-2)*(i-1)+(nLines-2)])
        push!(pf_result_perscen_normal, pf_result_normal[s+(nTP-1)*(s-1):s*nTP])
    end

    # pf_result_perscen_normal[10][24][1] is v_mag  and  pf_result_perscen_normal[10][24][2] is v_angle

    # violated_voltage_normal=[]
    relaxation_f=0.003
    min_violation=[]
    max_violation=[]
    voltage_viol_number=[]
    volt_viol_normal=Dict{Array{Int64,1},Float64}()

    for  s in 1, t in 1:nTP, b in 1:nBus
    violated_voltage_nr=findall(x->x>(nw_buses[b].bus_vmax)+relaxation_f || x<(nw_buses[b].bus_vmin)-relaxation_f, pf_result_perscen_normal[s][t][1][b])
    if ~isempty(violated_voltage_nr)
    #     println("NO vlotage violation")
    # else
        # push!(violated_voltage_normal,[s,t,violated_voltage_nr])
        # push!(min_violation,minimum(pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr))
        # push!(max_violation,maximum(pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr))
        # push!(violation_value,[pf_result_perscen_normal[s][t][1][i] for i in violated_voltage_nr])
        push!(volt_viol_normal, [s,t,b]=>pf_result_perscen_normal[s][t][1][b])

        push!(voltage_viol_number,1)
        # println("WARNING! vlotage violation in Scen $s, Time $t Bus $b ")
    end
    end


    branch_flow_check=[line_flow_violation(yij_line,yij_line_sh,idx_from_line,idx_to_line,pf_result_perscen_normal[s][t][1],pf_result_perscen_normal[s][t][2],nw_lines,s,t) for  s in 1, t in 1:nTP]
    # branch_flow_check[10,24][1] returns the Sij for all lines and branch_flow_check[10,24][2] returns the violated lines index and branch_flow_check[10,24][3] returns the violated percentage and branch_flow_check[10,24][4] counts the lines loaded over than 80%
    # branch_flow_check[10,24][3][1] returns the elements in the array
    # violated_q_n=[]
    #
    # for s=1:nSc,t=1:nTP,i in 1:nGens
    #     idx_reactive_violation=findall(x->x>qg_max[i]+epsilon_suf || x<qg_min[i]- epsilon_suf, pf_result_perscen_normal[s][t][3][i])
    #       if ~isempty(idx_reactive_violation)
    #           push!(violated_q_n,i)
    #          println("Reactive power violation in gen: $i ")
    #       # else
    #       #     println("No reactive power violation in normal op.")
    #       end
    #
    #   end
    # if isempty(violated_q_n)
    #      println("No reactive power violation in normal op.")
    # end
    power_flow_normal_result=Dict(
    "all_results"=>all_results,
    "pf_result_perscen_normal"=>pf_result_perscen_normal,
    "branch_flow_check"=>branch_flow_check,
    "voltage_viol_number"=>voltage_viol_number,
    "volt_viol_normal"=>volt_viol_normal,
    "convergence"    => idx_conv_normal
    )
    return power_flow_normal_result
end
end

function Y_bus(nBus, node_data,node_data_trans,
    # optim_tratio_normal,
    nw_trans,rdata_transformers)
    ybus=zeros(ComplexF64,nBus,nBus)
    for i in 1:nBus
        for k in 1:nBus
        if  ~isempty(node_data[i,1].node_num)

                if i==k
                ybus[i,i]= sum(node_data[i,1].node_gij_sr[j,1] + im*node_data[i,1].node_bij_sr[j,1]+ (node_data[i,1].node_gij_sh[j,1]+ im*node_data[i,1].node_bij_sh[j,1]  )./2 for j in 1:size(node_data[i,1].node_num,1))
                elseif i!=k

                for j in 1:size(node_data[i,1].node_num,1)
                        cnctd_nd     = node_data[i,1].node_cnode[j,1]
                        # idx_cnctd_nd = findall(x->x==cnctd_nd,rdata_buses[:,1])
                        idx_cnctd_nd = cnctd_nd
                ybus[i,idx_cnctd_nd]=-(node_data[i,1].node_gij_sr[j,1] + im*node_data[i,1].node_bij_sr[j,1])
                end
                end
            end
            end
        end




          for i in 1:nBus

           if  ~isempty(node_data_trans[i,1].node_num)


                    for j in 1:size(node_data_trans[i,1].node_num,1)                                                # length of each node vector in 'node_data' variable
                 #        gij_line_transf    = node_data_trans[i,1].node_gij_sr[j,1]
                 #        bij_line_transf    = node_data_trans[i,1].node_bij_sr[j,1]
                        cnctd_nd = node_data_trans[i,1].node_cnode[j,1]
                        # idx_cnctd_nd_trans = findall(x->x==cnctd_nd,rdata_buses[:,1])
                        idx_cnctd_nd_trans = cnctd_nd
                 #        gij_line_sh_transf = node_data_trans[i,1].node_gij_sh[j,1]
                 #        bij_line_sh_transf = node_data_trans[i,1].node_bij_sh[j,1]
                 #
                         tratio             = 1/node_data_trans[i,1].node_tratio[j,1]
                 ybus[i,idx_cnctd_nd_trans] = ybus[i,idx_cnctd_nd_trans]+tratio*(-(node_data_trans[i,1].node_gij_sr[j,1] + im*node_data_trans[i,1].node_bij_sr[j,1]))

                 from_node=findall3(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
                 to_node  =findall3(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)

                 check_idx= intersect(from_node,to_node)
                 if ~isempty(check_idx)  #this means from


                 ybus[i,i]=ybus[i,i]+tratio^2*(node_data_trans[i,1].node_gij_sr[j,1]+im*node_data_trans[i,1].node_bij_sr[j,1]+(node_data_trans[i,1].node_gij_sh[j,1]+im*node_data_trans[i,1].node_bij_sh[j,1]  )./2 )

             elseif isempty(check_idx)
             # elseif isempty(idx_from) && ~isempty(idx_to)

                 ybus[i,i]= ybus[i,i] +(node_data_trans[i,1].node_gij_sr[j,1] + im*node_data_trans[i,1].node_bij_sr[j,1]+ (node_data_trans[i,1].node_gij_sh[j,1]+ im*node_data_trans[i,1].node_bij_sh[j,1]  )./2 )

                 end


 end
 end
 end

        return ybus
end


# vay_bus=Y_bus(nBus, node_data,node_data_trans,
#     # optim_tratio_normal,
#     nw_trans,rdata_transformers)


function ac_power_flow_model(initialization, slack_bus_type,vol_ctrl_bus_type,load_bus_type,
 nBus,rdata_buses,
 nw_gens_pf,
 v_mag_pf,v_angle_pf,
 node_data,node_data_trans,
 # optim_tratio_normal,
 nw_trans,rdata_transformers,
 nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
 active_gen,reactive_gen,
 # lsh_indic,
 # res_shed_indic,
 nd_load_curt_vec,
 nd_ren_curt_vec,
 nd_shunt_vec,
 p_fl_inc_vec,
 p_fl_dec_vec,
 p_ch_vec,
 p_dis_vec,
 epsilon,iteration,itr_max,
 old_num_PV_buses_pf,
 p_sch_pf,
 q_sch_pf,
 p_node_pf,
 q_node_pf,
 y_bus,
 idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
 J11,J12,J21,J22,
 num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
 t
  )

  nw_lines_pf=initialization["nw_lines_pf"]
  # nw_loads_pf=initialization["nw_loads_pf"]
  nw_gens_pf=initialization["nw_gens_pf"]
  nw_sbase_pf=initialization["nw_sbase_pf"]
  v_initial_pf=initialization["v_initial_pf"]
  epsilon=initialization["epsilon"]
  epsilon_suf=initialization["epsilon_suf"]
  iteration=initialization["iteration"]
  itr_max=initialization["itr_max"]
  maxiter=initialization["maxiter"]
  load_bus_type=initialization["load_bus_type"]
  vol_ctrl_bus_type=initialization["vol_ctrl_bus_type"]
  slack_bus_type=initialization["slack_bus_type"]
  v_sp_pf=initialization["v_sp_pf"]
  node_vol_pf=initialization["node_vol_pf"]
  v_angle_pf=initialization["v_angle_pf"]
    # (slack_bus_type,vol_ctrl_bus_type,load_bus_type,rdata_buses,rdata_loads,rdata_gens,rdata_storage,nw_pPrf_data_load,
    # nw_qPrf_data_load,nw_pPrf_data_gen_max,nw_qPrf_data_gen_max,scenario_data_p_min,scenario_data_p_max,scenario_data_q_min,scenario_data_q_max,nw_buses_pf,
    # nw_lines_pf,nw_loads_pf,nw_gens_pf,nw_gcost_pf,nw_sbase_pf,v_initial_pf,v_mag_pf,v_angle_pf,max_mismatch_pf,epsilon,iteration,itr_max,ordata_buses_pf,
    # p_curt_pf,p_dis_pf,p_ch_pf,p_od_pf,p_ud_pf,load_theta,nd_curt_gen,nd_fl,nd_Str_active,dg_ac_pf,q_dg_opf,flex_adpf)

vol_nodes_mag_pf   = zeros(size(rdata_buses,1))
vol_nodes_theta_pf = zeros(size(rdata_buses,1))
# vol_rect_pf      = zeros(ComplexF64,size(nw_buses_pf,1))



    # ac_pf_con  = []

    # for i in 1:length(idx_cmb_pf)
    #     nd_num = nw_gens_pf[i].gen_bus_num
    #     sp_vol = nw_gens_pf[i].gen_V_set
    #     idx = findall(x->x==nd_num,rdata_buses[:,1])
    #     v_mag_pf[idx[1,1]] = sp_vol
    #     # v_mag_pf[idx[1,1]] =  v_mag
    # end
    # v_mag_pf =  v_mag

 ### ------------------- Average Scenario Generation ------------------------####
    # if scenario == 0 && nTP_pf == 1                                              # Deterministic Single-Period AC-Power Flow
    #     active_gen   = rdata_gens[:,9]./sbase                                    # P_max column in 'Gens' sheet
    #     # reactive_gen = rdata_gens[:,4]./sbase                                  # Q_max column in 'Gens' sheet
    #     reactive_gen = tan(acos(dg_ac_pf)).*active_gen                            # Q_max column in 'Gens' sheet
    #
    # elseif scenario == 0 && nTP_pf > 1                                           # Deterministic Multi-Period AC-Power Flow
    #     active_gen   = nw_pPrf_data_gen_max[:,2:end]./sbase                      # P_max values in 'P_Profiles_Gen_Max'
    #     # reactive_gen = nw_qPrf_data_gen_max[:,2:end]./sbase                    # Q_max values in 'Q_Profiles_Gen_Max'
    #     reactive_gen = tan(acos(dg_ac_pf)).*active_gen                           # Q_max values in 'Q_Profiles_Gen_Max'
    # elseif scenario == 1 && nTP_pf>1
    #     if nSc_pf == 1                                                              # Average Sochastic Multi-Period AC-Power Flow
    #         active_gen   = avg_scenario_gen(prob_scs,scenario_data_p_max,nTP_pf,nGens)    # nGens = total number of generators
    #         # reactive_gen = avg_scenario_gen(prob_scs,scenario_data_q_max,nTP_pf,nGens)    # nGens = total number of generators
    #         reactive_gen = tan(acos(dg_ac_pf)).*active_gen
    #     elseif nSc_pf>1                                                            # Full Stocahstic Multi-Period Problem
    #         active_gen   = scenario_data_p_max                                   # Full Stochastic Multi-Period AC-Power Flow
    #         reactive_gen = scenario_data_q_max
    #     end
    # end

### ------------------------------------------------------------------------####
#     J11 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
#     J12 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
#     J21 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
#     J22 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
#
# ## ---------------- Formation of Admittance matrix -----------------------------
#     # y_bus = Y_bus(nw_lines_pf,nw_buses_pf)
#     y_bus = Y_bus(nBus, node_data,node_data_trans,
#     optim_tratio_normal,
#     nw_trans,rdata_transformers)
##-------------------------- AC-Power Flow Iteration ------------------------ ##
# v_mag_pf_old    = deepcopy(v_mag_pf)
# v_angle_pf_old  = deepcopy(v_angle_pf)
# for s in 1:nSc_pf
    # for t in 1:nTP_pf
        # if t>=1
            max_mismatch_pf = 1
            iteration       = 0
            # v_mag_pf    = deepcopy(v_mag_pf_old)
            # v_angle_pf  = deepcopy(v_angle_pf_old)
        # end

        # println("")
        # if num_slack_bus_pf>1
        #     println("ERROR! There are more than 1 swing buses in the data. Please correct the data provided!")
        #     println("WARNING! The load flow program is terminated without running!")
        # else
            # p_sch_pf   = zeros(size(nw_buses_pf,1)-num_slack_bus_pf)                              # Net schedule active power except slack bus
            # q_sch_pf   = zeros(size(nw_buses_pf,1)-num_slack_bus_pf)                              # Net schedule reactive power except slack bus
            # p_node_pf  = zeros(size(nw_buses_pf,1)-num_slack_bus_pf)                              # Injected active power vector (dimension is one less than the number of nodes; excludes slack bus)                                    # Injected active power
            # q_node_pf  = zeros(size(nw_buses_pf,1)-num_slack_bus_pf)                              # Injected reactive power vector (dimension is one less than the number of nodes; excludes slack bus)
####------------ Schedule (specified) Power at PQ/PV buses ------------------ ##
#### ------- Determining P_Gen-P_load at PQ buses as well as PV buses ----------
            idx_sch = 0
            # (p_sch_pf,q_sch_pf) = schd_power(nw_buses_pf,nw_gens_pf,nw_loads_pf,rdata_buses,rdata_gens,rdata_loads,nw_pPrf_data_load,nw_qPrf_data_load,active_gen,reactive_gen,p_sch_pf,q_sch_pf,idx_sch,nw_sbase_pf,t,s,p_curt_pf,p_dis_pf,p_ch_pf,p_od_pf,p_ud_pf,rdata_storage,load_theta,nd_curt_gen,nd_fl,nd_Str_active,dg_ac_pf,q_dg_opf,flex_adpf)
            (p_sch_pf,q_sch_pf) = schedule_power(
                rdata_buses,nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
                active_gen,reactive_gen,
                p_sch_pf,q_sch_pf,
                # idx_sch,
                # nw_sbase,
                # lsh_indic,
                # res_shed_indic,
                nd_load_curt_vec,
                nd_ren_curt_vec,
                nd_shunt_vec,
                p_fl_inc_vec,
                p_fl_dec_vec,
                p_ch_vec,
                p_dis_vec,
                initialization
                    )

            idx_sch = 0
##------- Conversion from Cartesian coordiantes to Polar coordinates ---------##
            idx   = 0
            idx_i = 0
            idx_j = 0

            # org_idx_PV_buses_pf = zeros(size(idx_oPV_buses_pf))
            mdf_idx_PV_buses_pf = zeros(size(idx_oPV_buses_pf))
            org_idx_PV_buses_pf = idx_oPV_buses_pf
            # println("Scenario: S = $s")
            # println("Time Period: T = $t")
           convergence_indicator=0
            while max_mismatch_pf > epsilon && iteration<=itr_max
                # println("Iteration: $iteration")
#### ---------Information about the indices of PV and PQ buses ------------ ###
##-----Indices of PV buses to be deleted from Jacobian and mismatch vector -----
                (idx_dPV_buses,idx_dPQ_buses) = pv_pq_data(idx_PV_buses_pf,idx_slack_bus_pf,idx_PQ_buses_pf) # Modified indices of PV and PQ buses which will be used while deleting specific rows and columns in Jacobian Matrix
##------------- Calculation of vector y-f(x) (mismatch vector) --------------###
                (delta_mismatch_inj,p_injection,q_injection) = mismatch_vector(rdata_buses,v_angle_pf,v_mag_pf,y_bus,p_node_pf,q_node_pf,idx_dPV_buses,p_sch_pf,q_sch_pf)
##-------------------- Formation of Jacobian Matrix -------------------------###
                Jacob = jacobian(rdata_buses,v_angle_pf,v_mag_pf,y_bus,J11,J12,J21,J22,idx_dPV_buses,p_injection,q_injection)
##------------------ Solving for delta x = inv(J)*delta y -------------------###
                Jcb=lu(Jacob, check=false)
                if !issuccess(Jcb)

                    println("")
                    show("Sigularity observed for time: $t")
                    println("")
                    break
                end
                delta_x_pf = Jcb\delta_mismatch_inj
                # delta_x_pf = Jcb*delta_mismatch_inj
                # delta_x_pf = inv(J)*delta_mismatch_inj
##--------------------- Retrieving voltage magnitude and angles -------------###
                (v_angle_sv,v_mag_sv) = solution_voltage(slack_bus_type,rdata_buses,idx_PQ_buses_pf,idx_PV_buses_pf,idx_dPQ_buses,idx_dPV_buses,v_angle_pf,v_mag_pf,delta_x_pf,idx_slack_bus_pf)
                v_mag_pf   = v_mag_sv                                                  # sv = solution voltage (Here, voltage is updated)
                v_angle_pf = v_angle_sv

##------------------------- PV-PQ Switching ---------------------------------###
max_mismatch_pf   = maximum(abs.(delta_mismatch_inj))
max_mismatch_pf_P = maximum(abs.(delta_mismatch_inj[1:(num_PV_buses_pf+num_PQ_buses_pf)]))
max_mismatch_pf_Q = maximum(abs.(delta_mismatch_inj[(num_PV_buses_pf+num_PQ_buses_pf)+1:end]))
             if max_mismatch_pf_P<0.05
                (rdata_buses_sw,reactive_gen_sw) = pv_pq_switching(initialization, y_bus,nw_qPrf,v_mag_pf,v_angle_pf,rdata_buses,rdata_gens,idx_oPV_buses_pf,load_bus_type,vol_ctrl_bus_type,mdf_idx_PV_buses_pf,nd_shunt_vec,reactive_gen)
               # nw_buses_pf=nw_buses_pf_sw
               # rdata_buses=rdata_buses_sw
               # nw_gens_pf=nw_gens_pf_sw
                check_pv_buses_pf = length(findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2]))
                if check_pv_buses_pf!=old_num_PV_buses_pf                            # Switching of PV bus to PQ has taken place
                    # println("There is  PQ-PV switching in iter:$iteration ")
                    # nw_buses_pf=nw_buses_pf_sw
                    rdata_buses=rdata_buses_sw
                    reactive_gen=reactive_gen_sw
                    idx_slack_bus_pf = findall3(x->x==slack_bus_type,rdata_buses[:,2])
                    idx_PV_buses_pf  = findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2])
                    idx_PQ_buses_pf  = findall3(x->x==load_bus_type,rdata_buses[:,2])

                    # idx_oPV_buses_pf = findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2])

                    num_slack_bus_pf = length(idx_slack_bus_pf)
                    num_PQ_buses_pf  = length(idx_PQ_buses_pf)
                    num_PV_buses_pf  = length(idx_PV_buses_pf)

                    old_num_PV_buses_pf = num_PV_buses_pf
                    new_num_PV_buses_pf = num_PV_buses_pf
                    (p_sch_pf,q_sch_pf) = schedule_power(
                        rdata_buses,nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
                        active_gen,reactive_gen,
                        p_sch_pf,q_sch_pf,
                        # idx_sch,
                        # nw_sbase,
                        # lsh_indic,
                        # res_shed_indic,
                        nd_load_curt_vec,
                        nd_ren_curt_vec,
                        nd_shunt_vec,
                        p_fl_inc_vec,
                        p_fl_dec_vec,
                        p_ch_vec,
                        p_dis_vec,
                        initialization
                            )
                end
                old_num_PV_buses_pf = check_pv_buses_pf
            end

####--------------------------------------------------------------------#######

                iteration = iteration+1
                # println("Maximum mismatch P: $max_mismatch_pf_P")
                # println("Maximum mismatch Q: $max_mismatch_pf_Q")
            end # End while loop
            push!(maxiter,iteration)
        # end     # End If condition
####--------- Priniting the OUTCOME of AC Power Flow Solution --------------####
        oPV_bus_type = ordata_buses_pf
        nPV_bus_type = rdata_buses[:,2]
        switch_PV    = oPV_bus_type-nPV_bus_type
        idx_sPV      = findall3(x->x!=0,switch_PV)
        # println("")
        for i in 1:length(idx_sPV)
            nd_num = Int64(rdata_buses[idx_sPV[i,1],1])
            # println("WARNING! Generator G$nd_num bus has not switched back as PV!")
        end
## Print message whether the power flow algorithm is solved correctly or not ###
            # println("")
            if max_mismatch_pf<epsilon && iteration < itr_max
                # show("The power flow has converged successfully")
                convergence_indicator=1
                # println("The maximum mismatch is $max_mismatch_pf")
                # println("The converged solution is obtained in $iteration iterations" )
                # push!(ac_pf_con,"converged")
            # elseif max_mismatch_pf>epsilon && iteration >= itr_max
            else

                println("")
                show("The power flow has NOT converged for time $t in the required number of iteration")
                println("")
                # println("The maximum mismatch is $max_mismatch_pf")
                # println("The iteration has hit the limit:: $iteration")
                # push!(ac_pf_con,"Not converged")
            end
            # println("")
            for i in 1:size(rdata_buses,1)
                # vol_nodes_mag_pf[s,t,i]   = v_mag_pf[i]
                vol_nodes_mag_pf[i]   = v_mag_pf[i]
                # vol_nodes_theta_pf[:,t,i] .= rad2deg(v_angle_pf[i])
                # vol_nodes_theta_pf[s,t,i] = (v_angle_pf[i])                         # Angles are in Radian Because input of Cosine and Sine functions are in radian (i.e., Julia consideres them as radian)
                vol_nodes_theta_pf[i] = (v_angle_pf[i])                         # Angles are in Radian Because input of Cosine and Sine functions are in radian (i.e., Julia consideres them as radian)

                # vol_rect_pf[s,t,i] = v_mag_pf[i]*(cos(v_angle_pf[i]) + sin(v_angle_pf[i])im)
                # vol_rect_pf[i] = v_mag_pf[i]*(cos(v_angle_pf[i]) + sin(v_angle_pf[i])im)
                # vol_rect_pf[i] = v_mag_pf[i]*(cos(v_angle_pf[i]))
            end
    # end  # End Time loop
# end      # End Scneario Loop
################################################################################
##--------------- Retrieve the value of line loadings ------------------------##
################################################################################


################################################################################
##---------- Retrieve the value of injections and voltages -------------------##
################################################################################
p_node_pf_calc_pf,q_node_pf_calc_pf, p_schedule_node_pf,q_schedule_node_pf=lefthand_pb(
    rdata_buses,nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
    active_gen,reactive_gen,
    p_sch_pf,q_sch_pf,
    # idx_sch,
    # nw_sbase,
    # lsh_indic,
    # res_shed_indic,
    nd_load_curt_vec,
    nd_ren_curt_vec,
    nd_shunt_vec,
    p_fl_inc_vec,
    p_fl_dec_vec,
    p_ch_vec,
    p_dis_vec,
    initialization,
    y_bus,
    vol_nodes_mag_pf,
    vol_nodes_theta_pf
        )
# for s in 1:nSc_pf
#     for t in 1:nTP_pf

# WARNING : Do not activate the P and Q out put or put the correct values for FL and ST and PV
# for i in 1:size(nw_gens_pf,1)
#     nd_num   = nw_gens_pf[i].gen_bus_num
#     idx_nd_bsheet = convert(Int64,nd_num)
#     bus_type = rdata_buses[idx_nd_bsheet[1,1],2]
#         if !isnothing(idx_nd_lsheet[[nd_num]])  &&  isnothing(idx_nd_shunt[[nd_num]])
#             push!(p_gen_node_pf, [i]=>values(p_node_pf_calc_pf[[idx_nd_bsheet[1,1]]])+nw_pPrf[idx_nd_lsheet[[nd_num]]])
#             push!(q_gen_node_pf, [i]=>values(q_node_pf_calc_pf[[idx_nd_bsheet[1,1]]])+nw_qPrf[idx_nd_lsheet[[nd_num]]])
#         elseif !isnothing(idx_nd_lsheet[[nd_num]]) &&  !isnothing(idx_nd_shunt[[nd_num]])
#             push!(p_gen_node_pf, [i]=>values(p_node_pf_calc_pf[[idx_nd_bsheet[1,1]]])+nw_pPrf[idx_nd_lsheet[[nd_num]]])
#             push!(q_gen_node_pf, [i]=>values(q_node_pf_calc_pf[[idx_nd_bsheet[1,1]]])+nw_qPrf[idx_nd_lsheet[[nd_num]]]-(nd_shunt_vec[idx_nd_shunt[[nd_num]]]) )
#         elseif isnothing(idx_nd_lsheet[[nd_num]]) &&  !isnothing(idx_nd_shunt[[nd_num]])
#             push!(p_gen_node_pf, [i]=>values(p_node_pf_calc_pf[[idx_nd_bsheet[1,1]]]))
#             push!(q_gen_node_pf, [i]=>values(q_node_pf_calc_pf[[idx_nd_bsheet[1,1]]])-(nd_shunt_vec[idx_nd_shunt[[nd_num]]]) )
#         else
#             push!(p_gen_node_pf, [i]=>values(p_node_pf_calc_pf[[idx_nd_bsheet[1,1]]]))
#             push!(q_gen_node_pf, [i]=>values(q_node_pf_calc_pf[[idx_nd_bsheet[1,1]]]))
#         end
# end


    return vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator
    # return vol_nodes_mag_pf,vol_nodes_theta_pf,q_gen_node_pf,convergence_indicator
end


function line_flow_violation(yij_line,yij_line_sh,idx_from_line,idx_to_line,vol_nodes_mag_pf,vol_nodes_theta_pf,nw_lines,s,t)

                   gij_lin = real(yij_line)
                   bij_lin = imag(yij_line)
                   gij_lin_sh = real(yij_line_sh)
                   bij_lin_sh = imag(yij_line_sh)
                   sij=zeros(length(idx_from_line))
   for i in 1:length(idx_from_line)
       idx_nd_nw_buses=idx_from_line[i]
       idx_cnctd_nd   =idx_to_line[i]
       gij_line     =gij_lin[i]
       bij_line     =bij_lin[i]
       gij_line_sh  =gij_lin_sh[i]
       bij_line_sh  =bij_lin_sh[i]
       # idx_bus_shunt   = findall3(x->x==idx_nd_nw_buses,rdata_shunts[:,1])
                   pinj_ij_sh      = (gij_line_sh/2+gij_line)*(vol_nodes_mag_pf[idx_nd_nw_buses]^2)        # Line shunt conductance (Must be divided by 2)
                   pinj_ij_sr1     = -bij_line*vol_nodes_mag_pf[idx_nd_nw_buses]*vol_nodes_mag_pf[idx_cnctd_nd]*sin(vol_nodes_theta_pf[idx_nd_nw_buses]-vol_nodes_theta_pf[idx_cnctd_nd])
                   pinj_ij_sr2     = -gij_line*vol_nodes_mag_pf[idx_nd_nw_buses]*vol_nodes_mag_pf[idx_cnctd_nd]*cos(vol_nodes_theta_pf[idx_nd_nw_buses]-vol_nodes_theta_pf[idx_cnctd_nd])

                   qinj_ij_sh      = -(bij_line_sh/2+bij_line)*(vol_nodes_mag_pf[idx_nd_nw_buses]^2)      # Line shunt susceptance (Must be divided by 2)
                   qinj_ij_sr1     =   bij_line*vol_nodes_mag_pf[idx_nd_nw_buses]*vol_nodes_mag_pf[idx_cnctd_nd]*cos(vol_nodes_theta_pf[idx_nd_nw_buses]-vol_nodes_theta_pf[idx_cnctd_nd])
                   qinj_ij_sr2     = -gij_line*vol_nodes_mag_pf[idx_nd_nw_buses]*vol_nodes_mag_pf[idx_cnctd_nd]*sin(vol_nodes_theta_pf[idx_nd_nw_buses]-vol_nodes_theta_pf[idx_cnctd_nd])

                   # end
              #  if ~isempty(idx_bus_shunt)
              #          idx_bus_shunt=idx_bus_shunt[1,1]
              #          shunt_expr_1 = nw_shunts[idx_bus_shunt].shunt_bsh0*(vol_nodes_mag_pf[idx_nd_nw_buses]^2)
              #
              #      pij = pinj_ij_sh+pinj_ij_sr1+pinj_ij_sr2
              #      qij = qinj_ij_sh+qinj_ij_sr1+qinj_ij_sr2-shunt_expr_1
              #      sij=(pij^2+qij^2)/(nw_lines[i].line_Smax_A)^2
              #     push!(pinj_expr,pij)
              #     push!(qinj_expr,qij)
              #     push!(line_flow_normmalized,sij)
              # else
                  pij = pinj_ij_sh+pinj_ij_sr1+pinj_ij_sr2
                  qij = qinj_ij_sh+qinj_ij_sr1+qinj_ij_sr2
                  sij[i]=sqrt((pij^2+qij^2))/(nw_lines[i].line_Smax_A)
                 # push!(pinj_expr,pij)
                 # push!(qinj_expr,qij)
                 # push!(line_flow_normmalized,sij)

             end
                idx_line_violation=findall3(x->x>1.001, sij)
                violated_line_index=[]
                violated_line_percent=[]
                  if !isempty(idx_line_violation)
                # println("NO line flow violation in normal operation")
            # else
                from=idx_from_line[idx_line_violation]
                to=  idx_to_line[idx_line_violation]
                push!(violated_line_index,idx_line_violation)
                push!(violated_line_percent,sij[idx_line_violation])
          # println("WARNING! line flow violation in Normal Scen $s, Time $t, Line $idx_line_violation connecting bus $from to $to")
                  end
                  idx_included_lines=findall3(x->x>=0.7, sij) #those who are congested over 80% of their limit
                  included_lines=[]
                  if ~isempty(idx_included_lines)
                      push!(included_lines,idx_included_lines)
                  end

                 return sij,violated_line_index,violated_line_percent,included_lines
             end


function pf_v_teta_dic_n()
# if indicator==1
    vmag=Dict{Array{Int64,1},Float64}()
    for  s in 1, t in 1:nTP, b in 1:nBus
    # voltage_mag_nr=findall3(x->x>nw_buses[b].bus_vmax || x<nw_buses[b].bus_vmin, first_pf[s][t][1][b])
    # if ~isempty(voltage_mag_nr)
        push!(vmag,[t,b]=>pf_result_perscen_normal[s][t][1][b])
    # end
    end

    vang=Dict{Array{Int64,1},Float64}()
    for  s in 1, t in 1:nTP, b in 1:nBus
        push!(vang,[t,b]=>pf_result_perscen_normal[s][t][2][b])
    end


    return vmag,vang
# elseif indicator==0


    # vmag=Dict{Array{Int64,1},Float64}()
    # for  s in 1:nSc, t in 1:nTP, b in 1:nBus
    # voltage_mag_nr=findall3(x->x>nw_buses[b].bus_vmax || x<nw_buses[b].bus_vmin, first_pf[s][t][1][b])
    # if ~isempty(voltage_mag_nr)
        # push!(vmag,[s,t,b]=>pf_result_perscen_normal[s][t][1][b])
    # end
    # end

    # vang=Dict{Array{Int64,1},Float64}()
    # for  s in 1:nSc, t in 1:nTP, b in 1:nBus
        # push!(vang,[s,t,b]=>pf_result_perscen_normal[s][t][2][b])
    # end


    # return vmag,vang
# end
end

function v_teta_dic_n_state_indep()
# if indicator==1
    vmag=Dict{Array{Int64,1},Float64}()
    for  s in 1, t in 1:nTP, b in 1:nBus
    # voltage_mag_nr=findall3(x->x>nw_buses[b].bus_vmax || x<nw_buses[b].bus_vmin, first_pf[s][t][1][b])
    # if ~isempty(voltage_mag_nr)
        push!(vmag,[t,b]=>1)
    # end
    end

    vang=Dict{Array{Int64,1},Float64}()
    for  s in 1, t in 1:nTP, b in 1:nBus
        push!(vang,[t,b]=>0)
    end


    return vmag,vang

end

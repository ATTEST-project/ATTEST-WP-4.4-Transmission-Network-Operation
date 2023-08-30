function PF_input_contin(initialization,type_post_PF,indicator)
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

if type_post_PF=="contin"
p_scheduled_contin=JuMP.value.(Pg_c[:,:,:,:])
q_scheduled_contin=zeros(nCont,nSc,nTP,nGens)
# # nd_shunt_c          =shunt_value_c[:,:,:,:]
# # nd_ren_curt_c       =JuMP.value.(pen_ws_c[:,:,:,:])
# # nd_load_curt_c      =JuMP.value.(pen_lsh_c[:,:,:,:])
v_mag_total_c=zeros(nCont,nSc,nTP,nBus)
if indicator=="v_sqr"
v_mag_total_c       =JuMP.value.(v_sq_c[:,:,:,:]).^0.5
elseif indicator=="v_pol"
v_mag_total_c      =voltage_gen_c
end
# # p_fl_inc_c          =JuMP.value.(p_fl_inc_c[:,:,:,:])
# # p_fl_dec_c          =JuMP.value.(p_fl_dec_c[:,:,:,:])
# # p_ch_c              =JuMP.value.(p_ch_c[:,:,:,:])
# # p_dis_c             =JuMP.value.(p_dis_c[:,:,:,:])
shunt_c=[]
if ~isempty(nw_shunts)
    dim=(length(1:nCont),length(1:nSc),length(1:nTP),length(1:nShnt))
    shunt_elem = zeros(Float64,dim)
    for c in 1:nCont,s in 1:nSc,t in 1:nTP
    shunt_elem[c,s,t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
    end

    push!(shunt_c,shunt_elem)
elseif isempty(nw_shunts)
    push!(shunt_c, zeros(nCont,nSc,nTP,1))
end
nd_shunt_c          =shunt_c[1]
# if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
if !isnothing(variable_by_name(model_name, "pen_ws_c[1,1,1,1]"))
    nd_ren_curt_c       =JuMP.value.(pen_ws_c[:,:,:,:])
else
    nd_ren_curt_c       =zeros(nCont,nSc,nTP,nRES)
end
if !isnothing(variable_by_name(model_name, "pen_lsh_c[1,1,1,1]"))
    nd_load_curt_c   =JuMP.value.(pen_lsh_c[:,:,:,:])
else
    nd_load_curt_c   =zeros(nCont,nSc,nTP,nLoads)
end

if !isnothing(variable_by_name(model_name, "p_fl_inc_c[1,1,1,1]"))
    p_flex_inc_c   =JuMP.value.(p_fl_inc_c[:,:,:,:])
else
    p_flex_inc_c   =zeros(nCont,nSc,nTP,nFl)
end

if !isnothing(variable_by_name(model_name, "p_fl_dec_c[1,1,1,1]"))
    p_flex_dec_c   =JuMP.value.(p_fl_dec_c[:,:,:,:])
else
    p_flex_dec_c   =zeros(nCont,nSc,nTP,nFl)
end
if !isnothing(variable_by_name(model_name, "p_ch_c[1,1,1,1]"))
    p_chrg_c   =JuMP.value.(p_ch_c[:,:,:,:])
else
    p_chrg_c   =zeros(nCont,nSc,nTP,nStr_active)
end
if !isnothing(variable_by_name(model_name, "p_dis_c[1,1,1,1]"))
    p_dis_ch_c   =JuMP.value.(p_dis_c[:,:,:,:])
else
    p_dis_ch_c   =zeros(nCont,nSc,nTP,nStr_active)
end

input_contin=Dict(
"p_scheduled_contin"=>p_scheduled_contin,
"q_scheduled_contin"=>q_scheduled_contin,
"nd_shunt_c"=>nd_shunt_c,
"nd_ren_curt_c"=>nd_ren_curt_c,
"nd_load_curt_c"=>nd_load_curt_c,
"v_mag_total_c"=>v_mag_total_c,
"p_flex_inc_c"=>p_flex_inc_c,
"p_flex_dec_c"=>p_flex_dec_c,
"p_chrg_c"=>p_chrg_c,
"p_dis_ch_c"=>p_dis_ch_c

)
return input_contin

elseif type_post_PF=="power_flow_check"
p_scheduled_contin=active_power_c
q_scheduled_contin=zeros(nCont,nSc,nTP,nGens)
# # nd_shunt_c          =shunt_value_c[:,:,:,:]
# # nd_ren_curt_c       =JuMP.value.(pen_ws_c[:,:,:,:])
# # nd_load_curt_c      =JuMP.value.(pen_lsh_c[:,:,:,:])

v_mag_total_c=V_avail_c
# if indicator=="v_sqr"
# v_mag_total_c       =JuMP.value.(v_sq_c[:,:,:,:]).^0.5
# elseif indicator=="v_pol"
# v_mag_total_c      =voltage_gen_c
# end
# # p_fl_inc_c          =JuMP.value.(p_fl_inc_c[:,:,:,:])
# # p_fl_dec_c          =JuMP.value.(p_fl_dec_c[:,:,:,:])
# # p_ch_c              =JuMP.value.(p_ch_c[:,:,:,:])
# # p_dis_c             =JuMP.value.(p_dis_c[:,:,:,:])
shunt_c=[]
if ~isempty(nw_shunts)
    dim=(length(1:nCont),length(1:nSc),length(1:nTP),length(1:nShnt))
    shunt_elem = zeros(Float64,dim)
    for c in 1:nCont,s in 1:nSc,t in 1:nTP
    shunt_elem[c,s,t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
    end

    push!(shunt_c,shunt_elem)
elseif isempty(nw_shunts)
    push!(shunt_c, zeros(nCont,nSc,nTP,1))
end
nd_shunt_c          =shunt_c[1]
# if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
# if !isnothing(variable_by_name(model_name, "pen_ws_c[1,1,1,1]"))
#     nd_ren_curt_c       =JuMP.value.(pen_ws_c[:,:,:,:])
# else
    nd_ren_curt_c       =zeros(nCont,nSc,nTP,nRES)
# end
# if !isnothing(variable_by_name(model_name, "pen_lsh_c[1,1,1,1]"))
#     nd_load_curt_c   =JuMP.value.(pen_lsh_c[:,:,:,:])
# else
    nd_load_curt_c   =zeros(nCont,nSc,nTP,nLoads)
# end

# if !isnothing(variable_by_name(model_name, "p_fl_inc_c[1,1,1,1]"))
#     p_flex_inc_c   =JuMP.value.(p_fl_inc_c[:,:,:,:])
# else
    p_flex_inc_c   =zeros(nCont,nSc,nTP,nFl)
# end

# if !isnothing(variable_by_name(model_name, "p_fl_dec_c[1,1,1,1]"))
#     p_flex_dec_c   =JuMP.value.(p_fl_dec_c[:,:,:,:])
# else
    p_flex_dec_c   =zeros(nCont,nSc,nTP,nFl)
# end
# if !isnothing(variable_by_name(model_name, "p_ch_c[1,1,1,1]"))
#     p_chrg_c   =JuMP.value.(p_ch_c[:,:,:,:])
# else
    p_chrg_c   =zeros(nCont,nSc,nTP,nStr_active)
# end
# if !isnothing(variable_by_name(model_name, "p_dis_c[1,1,1,1]"))
#     p_dis_ch_c   =JuMP.value.(p_dis_c[:,:,:,:])
# else
    p_dis_ch_c   =zeros(nCont,nSc,nTP,nStr_active)
# end

input_contin=Dict(
"p_scheduled_contin"=>p_scheduled_contin,
"q_scheduled_contin"=>q_scheduled_contin,
"nd_shunt_c"=>nd_shunt_c,
"nd_ren_curt_c"=>nd_ren_curt_c,
"nd_load_curt_c"=>nd_load_curt_c,
"v_mag_total_c"=>v_mag_total_c,
"p_flex_inc_c"=>p_flex_inc_c,
"p_flex_dec_c"=>p_flex_dec_c,
"p_chrg_c"=>p_chrg_c,
"p_dis_ch_c"=>p_dis_ch_c

)
return input_contin
elseif  type_post_PF=="SA"
    # isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nBus)[1])
    # Pg_avail=zeros(nSc,nTP,nGens)
    # Qg_avail=zeros(nSc,nTP,nGens)
    # for i in 1:nGens
    #     Pg_avail[nSc,nTP,i]=nw_gens[i].gen_Pg_avl
    #     Qg_avail[nSc,nTP,i]=nw_gens[i].gen_Qg_avl
    # end
    # # [nw_gens[i].gen_Pg_avl for i in 1:nGens]
    # # Qg_avail=[nw_gens[i].gen_Qg_avl for i in 1:nGens]
    # V_avail=ones(nSc,nTP,nBus)
    # # V_avail=V_avail_aux[:,1]
    # for i in 1:nBus
    #     for j in 1:nGens
    #         if i==nw_gens[j].gen_bus_num
    #             V_avail[nSc,nTP,i]=nw_gens[j].gen_V_set
    #
    #         end
    #     end
    # end
    p_scheduled_contin=active_generation
    q_scheduled_contin=zeros(nSc,nTP,nGens)
    v_mag_total_c=voltage_gen

    # p_scheduled_contin=JuMP.value.(Pg[:,:,:])
    # q_scheduled_contin=zeros(nSc,nTP,nGens)
    # p_scheduled_contin=Pg_avail
    # q_scheduled_contin=Qg_avail

    # nd_shunt          =shunt_value[:,:,:]
    # nd_ren_curt       =JuMP.value.(pen_ws[:,:,:])
    # nd_load_curt      =JuMP.value.(pen_lsh[:,:,:])
    # v_mag_total_c       =voltage_gen
    # v_mag_total_c       =V_avail
    # p_scheduled_contin=JuMP.value.(Pg[:,:,:])
    # q_scheduled_contin=JuMP.value.(Qg[:,:,:])
    # # # nd_shunt_c          =shunt_value_c[:,:,:,:]
    # # # nd_ren_curt_c       =JuMP.value.(pen_ws_c[:,:,:,:])
    # # # nd_load_curt_c      =JuMP.value.(pen_lsh_c[:,:,:,:])
    # v_mag_total_c       =JuMP.value.(v_sq[:,:,:]).^0.5
    # # p_fl_inc_c          =JuMP.value.(p_fl_inc_c[:,:,:,:])
    # # p_fl_dec_c          =JuMP.value.(p_fl_dec_c[:,:,:,:])
    # # p_ch_c              =JuMP.value.(p_ch_c[:,:,:,:])
    # # p_dis_c             =JuMP.value.(p_dis_c[:,:,:,:])
    shunt_c=[]
    if ~isempty(nw_shunts)
        dim=(length(1:nSc),length(1:nTP),length(1:nShnt))
        shunt_elem = zeros(Float64,dim)
        for s in 1:nSc,t in 1:nTP
        shunt_elem[s,t,:]=[nw_shunts[i].shunt_bsh0 for i in 1:nShnt]
end

        push!(shunt_c,shunt_elem)
    elseif isempty(nw_shunts)
        push!(shunt_c, zeros(nSc,nTP,1))
    end
    nd_shunt_c          =shunt_c[1]
    # if !isnothing(variable_by_name.(model_name, "lsh[$i,$j,$k]" for i in 1:nSc, j in 1:nTP, k in 1:nLoads)[1])
    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "pen_ws[1,1]"))
        nd_ren_curt_c       =JuMP.value.(pen_ws[:,:,:])
    else
        nd_ren_curt_c       =zeros(nTP,nRES)
    end
    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "pen_lsh[1,1]"))
        nd_load_curt_c   =JuMP.value.(pen_lsh[:,:,:])
    else
        nd_load_curt_c   =zeros(nTP,nLoads)
    end

    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "p_fl_inc[1,1]"))
        p_flex_inc_c   =JuMP.value.(p_fl_inc[:,:,:])
    else
        p_flex_inc_c   =zeros(nTP,nFl)
    end

    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "p_fl_dec[1,1]"))
        p_flex_dec_c   =JuMP.value.(p_fl_dec[:,:,:])
    else
        p_flex_dec_c   =zeros(nTP,nFl)
    end
    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "p_ch[1,1]"))
        p_chrg_c   =JuMP.value.(p_ch[:,:,:])
    else
        p_chrg_c   =zeros(nTP,nStr_active)
    end
    if @isdefined(model_name) && !isnothing(variable_by_name(model_name, "p_dis[1,1]"))
        p_dis_ch_c   =JuMP.value.(p_dis[:,:,:])
    else
        p_dis_ch_c   =zeros(nTP,nStr_active)
    end

    input_contin=Dict(
    "p_scheduled_contin"=>p_scheduled_contin,
    "q_scheduled_contin"=>q_scheduled_contin,
    "nd_shunt_c"=>nd_shunt_c,
    "nd_ren_curt_c"=>nd_ren_curt_c,
    "nd_load_curt_c"=>nd_load_curt_c,
    "v_mag_total_c"=>v_mag_total_c,
    "p_flex_inc_c"=>p_flex_inc_c,
    "p_flex_dec_c"=>p_flex_dec_c,
    "p_chrg_c"=>p_chrg_c,
    "p_dis_ch_c"=>p_dis_ch_c

    )
    return input_contin
    end
end

function loop_free_c(initialization)
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
J11,
J12 ,
J21 ,
J22 ,
p_sch_pf  ,
q_sch_pf   ,
p_node_pf  ,
q_node_pf
end


function run_PF_contin(initialization,input_contin,type_post_PF)
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

    p_scheduled_contin=input_contin["p_scheduled_contin"]
    q_scheduled_contin=input_contin["q_scheduled_contin"]
    nd_shunt_c=input_contin["nd_shunt_c"]
    nd_ren_curt_c=input_contin["nd_ren_curt_c"]
    nd_load_curt_c=input_contin["nd_load_curt_c"]
    v_mag_total_c=input_contin["v_mag_total_c"]
    p_flex_inc_c=input_contin["p_flex_inc_c"]
    p_flex_dec_c=input_contin["p_flex_dec_c"]
    p_chrg_c=input_contin["p_chrg_c"]
    p_dis_ch_c=input_contin["p_dis_ch_c"]

    pf_result=[]
    # all_results=[]
    all_results=Dict{Array{Int64,1},Dict{Symbol,Any}}()
    idx_converge=[]
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
J11,
J12 ,
J21 ,
J22 ,
p_sch_pf  ,
q_sch_pf   ,
p_node_pf  ,
q_node_pf)=loop_free_c(initialization)
# include("functions/only_pf_function_contin.jl")

for c in 1:nCont
    y_bus_c = Y_bus_c(initialization, nBus, node_data_contin,c,node_data_trans,
    # optim_tratio_normal_c,
    nw_trans,rdata_transformers)
    for  s in 1:nSc, t in 1:nTP
        # println("")
        # show("Power flow is running for Contin:$c, Scen:$s, Time:$t")
        # println("")

# for c in 1, s in 1, t in 1
if type_post_PF=="contin"  || type_post_PF=="power_flow_check"
rdata_buses[:,2]=deepcopy([nw_buses[i].bus_type for i in 1:nBus])
ordata_buses_pf=deepcopy([nw_buses[i].bus_type for i in 1:nBus])

active_gen_c  =p_scheduled_contin[c,s,t,:]
reactive_gen_c=q_scheduled_contin[c,s,t,:]
# active_gen_c  =p_scheduled_contin[c,s,t,:]
# reactive_gen_c=q_scheduled_contin[c,s,t,:]
nd_shunt_vec_c=nd_shunt_c[c,s,t,:]
nd_ren_curt_vec_c=nd_ren_curt_c[c,s,t,:]
nd_load_curt_vec_c=nd_load_curt_c[c,s,t,:]

nw_pPrf=prof_ploads[:,t]
nw_qPrf=prof_qloads[:,t]
prof_PRES_vec=prof_PRES[s,t,:]

p_fl_inc_vec_c=p_flex_inc_c[c,s,t,:]
p_fl_dec_vec_c=p_flex_dec_c[c,s,t,:]
p_ch_vec_c    =p_chrg_c[c,s,t,:]
p_dis_vec_c   =p_dis_ch_c[c,s,t,:]
v_mag_pf_c=v_mag_total_c[c,s,t,:]

(vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator)=ac_power_flow_model_c(initialization,slack_bus_type,vol_ctrl_bus_type,load_bus_type,
nBus,rdata_buses,
nw_gens_pf,
v_mag_pf_c,v_angle_pf,
node_data_contin,c,node_data_trans,
# optim_tratio_normal_c,
nw_trans,rdata_transformers,
nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
active_gen_c,reactive_gen_c,
# lsh_indic,
# res_shed_indic,
nd_load_curt_vec_c,
nd_ren_curt_vec_c,
nd_shunt_vec_c,
p_fl_inc_vec_c,
p_fl_dec_vec_c,
p_ch_vec_c,
p_dis_vec_c,
epsilon,iteration,itr_max,
old_num_PV_buses_pf,
p_sch_pf,
q_sch_pf,
p_node_pf,
q_node_pf,
y_bus_c,
idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
J11,J12,J21,J22,
num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
s,t
)

# push!(all_results,(vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf))
all_results_per_time=Dict(:v_mag=>vol_nodes_mag_pf_c,
                :v_ang=>vol_nodes_theta_pf_c,
                :p_cal=>p_node_pf_calc_pf,
                :q_cal=>q_node_pf_calc_pf,
                :p_sch=>p_schedule_node_pf,
                :q_sch=>q_schedule_node_pf)
                push!(all_results,[c,s,t]=>all_results_per_time)
push!(pf_result,(vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_schedule_node_pf,q_schedule_node_pf))
push!(idx_converge, convergence_indicator)

elseif type_post_PF=="SA"

    rdata_buses[:,2]=deepcopy([nw_buses[i].bus_type for i in 1:nBus])
    # obus_type_pf    = rdata_buses[:,2]  #types of buses slack pv pq
    # obus_type_pf= fixed_rdata_buses
    # ordata_buses_pf = obus_type_pf
    ordata_buses_pf=deepcopy([nw_buses[i].bus_type for i in 1:nBus])
    active_gen_c  =p_scheduled_contin[s,t,:]
    reactive_gen_c=q_scheduled_contin[s,t,:]
    # active_gen_c  =p_scheduled_contin[c,s,t,:]
    # reactive_gen_c=q_scheduled_contin[c,s,t,:]
    nd_shunt_vec_c=nd_shunt_c[s,t,:]
    nd_ren_curt_vec_c=nd_ren_curt_c[t,:]
    nd_load_curt_vec_c=nd_load_curt_c[t,:]

    nw_pPrf=prof_ploads[:,t]
    nw_qPrf=prof_qloads[:,t]
    prof_PRES_vec=prof_PRES[s,t,:]

    p_fl_inc_vec_c=p_flex_inc_c[t,:]
    p_fl_dec_vec_c=p_flex_dec_c[t,:]
    p_ch_vec_c    =p_chrg_c[t,:]
    p_dis_vec_c   =p_dis_ch_c[t,:]
    v_mag_pf_c=v_mag_total_c[s,t,:]

    (vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator)=ac_power_flow_model_c(initialization,slack_bus_type,vol_ctrl_bus_type,load_bus_type,
    nBus,rdata_buses,
    nw_gens_pf,
    v_mag_pf_c,v_angle_pf,
    node_data_contin,c,node_data_trans,
    # optim_tratio_normal_c,
    nw_trans,rdata_transformers,
    nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
    active_gen_c,reactive_gen_c,
    # lsh_indic,
    # res_shed_indic,
    nd_load_curt_vec_c,
    nd_ren_curt_vec_c,
    nd_shunt_vec_c,
    p_fl_inc_vec_c,
    p_fl_dec_vec_c,
    p_ch_vec_c,
    p_dis_vec_c,
    epsilon,iteration,itr_max,
    old_num_PV_buses_pf,
    p_sch_pf,
    q_sch_pf,
    p_node_pf,
    q_node_pf,
    y_bus_c,
    idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
    J11,J12,J21,J22,
    num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
    s,t
    )

    # push!(all_results,(vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf))
    all_results_per_time=Dict(:v_mag=>vol_nodes_mag_pf_c,
                    :v_ang=>vol_nodes_theta_pf_c,
                    :p_cal=>p_node_pf_calc_pf,
                    :q_cal=>q_node_pf_calc_pf,
                    :p_sch=>p_schedule_node_pf,
                    :q_sch=>q_schedule_node_pf)
                    push!(all_results,[c,s,t]=>all_results_per_time)
    push!(pf_result,(vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,p_schedule_node_pf,q_schedule_node_pf))
    push!(idx_converge, convergence_indicator)
    end
    end
end



pf_result_percontin=[]
for c in 1:nCont
    # push!(node_data_contin, node_data_c[i+(nLines-2)*(i-1):i+(nLines-2)*(i-1)+(nLines-2)])
    push!(pf_result_percontin, pf_result[c+(nSc*nTP-1)*(c-1):c*nSc*nTP])
end


pf_result_perscenario=[pf_result_percontin[c][s+(nTP-1)*(s-1):s*nTP] for c in 1:nCont,  s in 1:nSc]
pf_per_dimension=pf_result_perscenario
# pf_result_perscenario[33,10][24][1] is v_mag  and  pf_result_perscenario[33,10][24][2] is v_angle



idx_conv=[]
for c in 1:nCont
    idx_con=findall3(x->x==0, idx_converge )
    if ~isempty(idx_con)
    push!(idx_conv,idx_con)
end
end

if isempty(idx_conv)
    println("")
    # show("$idx_conv")
    show("The power flow has converged successfully for all contingencies")
    println("")
else
    println("")
    # show("$idx_conv")
    show("WARNING! The power flow has NOT converged successfully for some contingency cases")
    println("")

end

relaxation_f=0.003
voltage_viol_contin_number=[]
volt_viol_contin=Dict{Array{Int64,1},Float64}()

for c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
voltage_violation_c=findall(x->x>(nw_buses[b].bus_vmax+v_relax_factor_max)+relaxation_f || x<(nw_buses[b].bus_vmin-v_relax_factor_min)-relaxation_f, pf_per_dimension[c,s][t][1][b])
if ~isempty(voltage_violation_c)
#     println("NO vlotage violation")
# else
# push!(violated_voltage_contin,[c,s,t,voltage_violation_c])
push!(volt_viol_contin, [c,s,t,b]=>pf_per_dimension[c,s][t][1][b])
push!(voltage_viol_contin_number,1)
    from_to= [nw_lines[list_of_contingency_lines[c][1]].line_from nw_lines[list_of_contingency_lines[c][1]].line_to][1,:]
    # println("WARNING! voltage violation in Contin $c--> [connecting $from_to], Scen $s, Time $t Bus $b ")
end
end


# include("line_flow_violation_check_contin.jl")
branch_flow_check_c=[line_flow_violation_contin(yij_line_c,yij_line_sh_c,idx_from_line_c,idx_to_line_c,pf_per_dimension[c,s][t][1],pf_per_dimension[c,s][t][2],line_smax_c,c,s,t) for c in 1:nCont, s in 1:nSc, t in 1:nTP]
# branch_flow_check_c[33,10,24][1] returns sij branch_flow_check_c[33,10,24][2] returns the violated indices and  branch_flow_check_c[33,10,24][3] returns the violated percentage and branch_flow_check_c[33,10,24][4] counts the lines loaded over than 80%
# violated_q_c=[]
# for c in 1:nCont, s in 1:nSc, t in 1:nTP,i in 1:nGens
#     idx_reactive_violation=findall(x->x>qg_max[i]+epsilon_suf || x<qg_min[i]-epsilon_suf , pf_result_perscenario[c,s][t][3][i])
#       if ~isempty(idx_reactive_violation)
#           push!(violated_q_c,i)
#          println("Reactive power violation in contin: $c in gen: $i ")
#       # else
#       #     println("No reactive power violation in normal op.")
#       end
#   end
#   if isempty(violated_q_c)
#        println("No reactive power violation in all contingencies.")
#   end
power_flow_contin_result=Dict(
"all_results"=>all_results,
"pf_per_dimension"=>pf_per_dimension,
"branch_flow_check_c"=>branch_flow_check_c,
"voltage_viol_contin_number"=>voltage_viol_contin_number,
"volt_viol_contin"=>volt_viol_contin,
"convergence"    => idx_conv
)
return power_flow_contin_result#,violated_q_c

end




function Y_bus_c(initialization,nBus, node_data_contin,c,node_data_trans,
    # optim_tratio_normal_c,
    nw_trans,rdata_transformers)
    from_to_map=initialization["from_to_map"]
    ybus=zeros(ComplexF64,nBus,nBus)
    for i in 1:nBus
        for k in 1:nBus
        if  ~isempty(node_data_contin[c][i,1].node_num_c)

                if i==k
                ybus[i,i]= sum(node_data_contin[c][i,1].node_gij_sr_c[j,1] + im*node_data_contin[c][i,1].node_bij_sr_c[j,1]+ (node_data_contin[c][i,1].node_gij_sh_c[j,1]+ im*node_data_contin[c][i,1].node_bij_sh_c[j,1]  )./2 for j in 1:size(node_data_contin[c][i,1].node_num_c,1))
                elseif i!=k
                 # [ybus[i,node_data_contin[c][i,1].node_cnode_c[j,1]]=-(node_data_contin[c][i,1].node_gij_sr_c[j,1] + im*node_data_contin[c][i,1].node_bij_sr_c[j,1]) for j in 1:size(node_data_contin[c][i,1].node_num_c,1)]
                for j in 1:size(node_data_contin[c][i,1].node_num_c,1)
                        cnctd_nd     = node_data_contin[c][i,1].node_cnode_c[j,1]
                        # idx_cnctd_nd = findall(x->x==cnctd_nd,rdata_buses[:,1])
                        idx_cnctd_nd = cnctd_nd
                ybus[i,idx_cnctd_nd]=-(node_data_contin[c][i,1].node_gij_sr_c[j,1] + im*node_data_contin[c][i,1].node_bij_sr_c[j,1])
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

                 # from_node=findall(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
                 # to_node  =findall(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)
                 #
                 # check_idx= intersect(from_node,to_node)
                 check_idx=values(from_to_map[[i,j]])
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



function ac_power_flow_model_c(initialization,slack_bus_type,vol_ctrl_bus_type,load_bus_type,
nBus,rdata_buses,
nw_gens_pf,
v_mag_pf,v_angle_pf,
node_data_contin,c,node_data_trans,
# optim_tratio_normal_c,
nw_trans,rdata_transformers,
nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
active_gen_c,reactive_gen_c,
# lsh_indic,
# res_shed_indic,
nd_load_curt_vec_c,
nd_ren_curt_vec_c,
nd_shunt_vec_c,
p_fl_inc_vec_c,
p_fl_dec_vec_c,
p_ch_vec_c,
p_dis_vec_c,
epsilon,iteration,itr_max,
old_num_PV_buses_pf,
p_sch_pf,
q_sch_pf,
p_node_pf,
q_node_pf,
y_bus_c,
idx_oPV_buses_pf,idx_PV_buses_pf,idx_PQ_buses_pf,idx_slack_bus_pf,
J11,J12,J21,J22,
num_slack_bus_pf,num_PQ_buses_pf,num_PV_buses_pf,ordata_buses_pf,
s,t

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



    # vol_nodes_mag_pf   = zeros(nSc_pf,nTP_pf,size(nw_buses_pf,1))                      # Initialization of vol magnitue and vol angle terms. Everytime SC-PF is run, vol magnitudes should be set to zero
    # vol_nodes_theta_pf = zeros(nSc_pf,nTP_pf,size(nw_buses_pf,1))
    vol_nodes_mag_pf   = zeros(size(rdata_buses,1))                      # Initialization of vol magnitue and vol angle terms. Everytime SC-PF is run, vol magnitudes should be set to zero
    vol_nodes_theta_pf = zeros(size(rdata_buses,1))
    # # vol_rect_pf      = zeros(ComplexF64,(nSc_pf,nTP_pf,size(nw_buses_pf,1)))
    # vol_rect_pf      = zeros(ComplexF64,size(nw_buses_pf,1))
    # idx_slack_bus_pf = findall(x->x==slack_bus_type,rdata_buses[:,2])
    # idx_PV_buses_pf  = findall(x->x==vol_ctrl_bus_type,rdata_buses[:,2])
    # idx_PQ_buses_pf  = findall(x->x==load_bus_type,rdata_buses[:,2])
    #
    # idx_oPV_buses_pf = findall(x->x==vol_ctrl_bus_type,rdata_buses[:,2])
    #
    # num_slack_bus_pf = length(idx_slack_bus_pf)
    # num_PQ_buses_pf  = length(idx_PQ_buses_pf)
    # num_PV_buses_pf  = length(idx_PV_buses_pf)
    #
    # old_num_PV_buses_pf = num_PV_buses_pf
    # new_num_PV_buses_pf = num_PV_buses_pf
    #
    # idx_cmb_pf = vcat(idx_slack_bus_pf,idx_PV_buses_pf)
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
    # J11 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
    # J12 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
    # J21 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)
    # J22 = zeros(size(nw_buses_pf,1)-num_slack_bus_pf,size(nw_buses_pf,1)-num_slack_bus_pf)

## ---------------- Formation of Admittance matrix -----------------------------
    # y_bus = Y_bus(nw_lines_pf,nw_buses_pf)
    # y_bus_c = Y_bus_c(nBus, node_data_contin,c,node_data_trans,
    # optim_tratio_normal_c,
    # nw_trans,rdata_transformers)
##-------------------------- AC-Power Flow Iteration ------------------------ ##
v_mag_pf_old    = deepcopy(v_mag_pf)
v_angle_pf_old  = deepcopy(v_angle_pf)
# for s in 1:nSc_pf
    # for t in 1:nTP_pf
        # if t>=1
            max_mismatch_pf = 1
            iteration       = 0
            v_mag_pf    = deepcopy(v_mag_pf_old)
            v_angle_pf  = deepcopy(v_angle_pf_old)
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
           active_gen_c,reactive_gen_c,
           p_sch_pf,q_sch_pf,
           # nw_sbase,
           # lsh_indic,
           # res_shed_indic,
           nd_load_curt_vec_c,
           nd_ren_curt_vec_c,
           nd_shunt_vec_c,
           p_fl_inc_vec_c,
           p_fl_dec_vec_c,
           p_ch_vec_c,
           p_dis_vec_c,
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
                # while true
                # println("Iteration: $iteration")
#### ---------Information about the indices of PV and PQ buses ------------ ###
##-----Indices of PV buses to be deleted from Jacobian and mismatch vector -----
                (idx_dPV_buses,idx_dPQ_buses) = pv_pq_data(idx_PV_buses_pf,idx_slack_bus_pf,idx_PQ_buses_pf) # Modified indices of PV and PQ buses which will be used while deleting specific rows and columns in Jacobian Matrix
##------------- Calculation of vector y-f(x) (mismatch vector) --------------###
                (delta_mismatch_inj,p_injection,q_injection) = mismatch_vector(rdata_buses,v_angle_pf,v_mag_pf,y_bus_c,p_node_pf,q_node_pf,idx_dPV_buses,p_sch_pf,q_sch_pf)
##-------------------- Formation of Jacobian Matrix -------------------------###
                Jacob= jacobian(rdata_buses,v_angle_pf,v_mag_pf,y_bus_c,J11,J12,J21,J22,idx_dPV_buses,p_injection,q_injection)
##------------------ Solving for delta x = inv(J)*delta y -------------------###
                 # Jcb=lu(Jacob)
                 Jcb=lu(Jacob, check=false)
                 if !issuccess(Jcb)

                     println("")
                     show("Singular Jacobian for: contin:$c, scen:$s, time:$t")
                     println("")
                     break
                 end

                delta_x_pf = Jcb\delta_mismatch_inj
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
                (rdata_buses_sw,reactive_gen_sw) = pv_pq_switching(initialization,y_bus_c,nw_qPrf,v_mag_pf,v_angle_pf,rdata_buses,rdata_gens,idx_oPV_buses_pf,load_bus_type,vol_ctrl_bus_type,mdf_idx_PV_buses_pf,nd_shunt_vec_c,reactive_gen_c)

                check_pv_buses_pf = length(findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2]))
                if check_pv_buses_pf!=old_num_PV_buses_pf                            # Switching of PV bus to PQ has taken place
                     # println("There is  PQ-PV switching in iter:$iteration ")
                     # nw_buses_pf=nw_buses_pf_sw
                     rdata_buses=rdata_buses_sw
                     reactive_gen_c=reactive_gen_sw

                     idx_slack_bus_pf = findall3(x->x==slack_bus_type,rdata_buses[:,2])
                     idx_PV_buses_pf  = findall3(x->x==vol_ctrl_bus_type,rdata_buses[:,2])
                     idx_PQ_buses_pf  = findall3(x->x==load_bus_type,rdata_buses[:,2])

                     # idx_oPV_buses_pf = findall(x->x==vol_ctrl_bus_type,rdata_buses[:,2])

                     num_slack_bus_pf = length(idx_slack_bus_pf)
                     num_PQ_buses_pf  = length(idx_PQ_buses_pf)
                     num_PV_buses_pf  = length(idx_PV_buses_pf)

                     old_num_PV_buses_pf = num_PV_buses_pf
                     new_num_PV_buses_pf = num_PV_buses_pf

                     (p_sch_pf,q_sch_pf) = schedule_power(
                     rdata_buses,nw_pPrf,nw_qPrf,RES_bus,bus_data_gsheet,prof_PRES_vec,
                     active_gen_c,reactive_gen_c,
                     p_sch_pf,q_sch_pf,
                     # nw_sbase,
                     # lsh_indic,
                     # res_shed_indic,
                     nd_load_curt_vec_c,
                     nd_ren_curt_vec_c,
                     nd_shunt_vec_c,
                     p_fl_inc_vec_c,
                     p_fl_dec_vec_c,
                     p_ch_vec_c,
                     p_dis_vec_c,
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
        # oPV_bus_type = ordata_buses_pf
        # nPV_bus_type = rdata_buses[:,2]
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
                # println("The power flow has converged successfully")
                convergence_indicator=1
                # println("The maximum mismatch is $max_mismatch_pf")
                # println("The converged solution is obtained in $iteration iterations" )
                # println("converged for contin $c")
            # elseif max_mismatch_pf>epsilon && iteration >= itr_max
                else
                from_to= [nw_lines[list_of_contingency_lines[c][1]].line_from nw_lines[list_of_contingency_lines[c][1]].line_to][1,:]
                println("")
                show("The power flow for contin $c--> $from_to, Scen $s, time $t has NOT converged in the required number of iteration")
                println("")
                # break
            end
            # if   !issuccess(Jcb)
            #         println("")
            #         show("Singular Jacobian for: contin:$c, scen:$s, time:$t")
            #         println("")
            #         break
            #     # println("The maximum mismatch is $max_mismatch_pf")
            #     # println("The iteration has hit the limit:: $iteration")
            #     # push!(ac_pf_con,"Not converged")
            # end
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
    active_gen_c,reactive_gen_c,
    p_sch_pf,q_sch_pf,
    # idx_sch,
    # nw_sbase,
    # lsh_indic,
    # res_shed_indic,
    nd_load_curt_vec_c,
    nd_ren_curt_vec_c,
    nd_shunt_vec_c,
    p_fl_inc_vec_c,
    p_fl_dec_vec_c,
    p_ch_vec_c,
    p_dis_vec_c,
    initialization,
    y_bus_c,
    vol_nodes_mag_pf,
    vol_nodes_theta_pf
        )

# p_node_pf_calc_pf=[]
# q_node_pf_calc_pf=[]
# p_schedule_node_pf=[]
# q_schedule_node_pf=[]

return vol_nodes_mag_pf,vol_nodes_theta_pf,p_node_pf_calc_pf,q_node_pf_calc_pf,p_schedule_node_pf, q_schedule_node_pf, convergence_indicator
    # return vol_nodes_mag_pf,vol_nodes_theta_pf,q_gen_node_pf,convergence_indicator
    # return vol_nodes_mag_pf,vol_nodes_theta_pf,convergence_indicator
end

function line_flow_violation_contin(yij_line_c,yij_line_sh_c,idx_from_line_c,idx_to_line_c,vol_nodes_mag_pf_c,vol_nodes_theta_pf_c,line_smax_c,c,s,t)
                gij_lin = real(yij_line_c[c])
                bij_lin = imag(yij_line_c[c])
                gij_lin_sh = real(yij_line_sh_c[c])
                bij_lin_sh = imag(yij_line_sh_c[c])
                sij=zeros(length(idx_from_line_c[c]))
  for i in 1:length(idx_from_line_c[c])
    idx_nd_nw_buses=idx_from_line_c[c][i]
    idx_cnctd_nd   =idx_to_line_c[c][i]
    gij_line     =gij_lin[i]
    bij_line     =bij_lin[i]
    gij_line_sh  =gij_lin_sh[i]
    bij_line_sh  =bij_lin_sh[i]
    # idx_bus_shunt   = findall3(x->x==idx_nd_nw_buses,rdata_shunts[:,1])
                pinj_ij_sh      = (gij_line_sh/2+gij_line)*(vol_nodes_mag_pf_c[idx_nd_nw_buses]^2)        # Line shunt conductance (Must be divided by 2)
                pinj_ij_sr1     = -bij_line*vol_nodes_mag_pf_c[idx_nd_nw_buses]*vol_nodes_mag_pf_c[idx_cnctd_nd]*sin(vol_nodes_theta_pf_c[idx_nd_nw_buses]-vol_nodes_theta_pf_c[idx_cnctd_nd])
                pinj_ij_sr2     = -gij_line*vol_nodes_mag_pf_c[idx_nd_nw_buses]*vol_nodes_mag_pf_c[idx_cnctd_nd]*cos(vol_nodes_theta_pf_c[idx_nd_nw_buses]-vol_nodes_theta_pf_c[idx_cnctd_nd])

                qinj_ij_sh      = -(bij_line_sh/2+bij_line)*(vol_nodes_mag_pf_c[idx_nd_nw_buses]^2)      # Line shunt susceptance (Must be divided by 2)
                qinj_ij_sr1     =   bij_line*vol_nodes_mag_pf_c[idx_nd_nw_buses]*vol_nodes_mag_pf_c[idx_cnctd_nd]*cos(vol_nodes_theta_pf_c[idx_nd_nw_buses]-vol_nodes_theta_pf_c[idx_cnctd_nd])
                qinj_ij_sr2     = -gij_line*vol_nodes_mag_pf_c[idx_nd_nw_buses]*vol_nodes_mag_pf_c[idx_cnctd_nd]*sin(vol_nodes_theta_pf_c[idx_nd_nw_buses]-vol_nodes_theta_pf_c[idx_cnctd_nd])

               pij = pinj_ij_sh+pinj_ij_sr1+pinj_ij_sr2
               qij = qinj_ij_sh+qinj_ij_sr1+qinj_ij_sr2
               sij[i]=sqrt((pij^2+qij^2))/(line_smax_c[c][i])

       end
          idx_line_violation=findall3(x->x>1.001, sij)
          violated_line_index_c=[]
          violated_line_percent_c=[]

            if ~isempty(idx_line_violation)
                push!(violated_line_index_c,idx_line_violation)
                for i in idx_line_violation
                from=idx_from_line_c[c][i]
                to=  idx_to_line_c[c][i]
                push!(violated_line_percent_c,sij[i])
                from_to= [nw_lines[list_of_contingency_lines[c][1]].line_from nw_lines[list_of_contingency_lines[c][1]].line_to][1,:]
          # println("WARNING! line flow violation in Contin $c--> connecting bus $from_to, Scen $s, Time $t, Line $idx_line_violation" )
               end
            end
            idx_included_lines=findall3(x->x>=0.7, sij) #those who are congested over 80% of their limit
            included_lines_c=[]
            if ~isempty(idx_included_lines)
                push!(included_lines_c,idx_included_lines)
            end
           return sij,violated_line_index_c,violated_line_percent_c,included_lines_c
       end


function pf_v_teta_dic_c(iter_switch)
  if iter_switch==0   ##use the same (V, θ) points for all states
      # if indicator==1
       vmagc=Dict{Array{Int64,1},Float64}()
       for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
    # push!(first_pf_cont_vmag,[c,s,t,b]=>first_pf_c[c,s][t][1][b])
          push!(vmagc,[c,s,t,b]=>pf_result_perscen_normal[1][t][1][b])
         end

     vangc=Dict{Array{Int64,1},Float64}()
     for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
        push!(vangc,[c,s,t,b]=>pf_result_perscen_normal[1][t][2][b])
     end

    return vmagc,vangc
# elseif indicator==0
#     nSc=1
#     nTP=1
#     vmagc=Dict{Array{Int64,1},Float64}()
#     for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
#  # push!(first_pf_cont_vmag,[c,s,t,b]=>first_pf_c[c,s][t][1][b])
#        push!(vmagc,[c,s,t,b]=>pf_result_perscen_normal[s][t][1][b])
#       end
#
#   vangc=Dict{Array{Int64,1},Float64}()
#   for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
#      push!(vangc,[c,s,t,b]=>pf_result_perscen_normal[s][t][2][b])
#   end
#
#  return vmagc,vangc
# end
 elseif iter_switch==1 #use dedicated  initial points for each state
     vmagc=Dict{Array{Int64,1},Float64}()
     for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
  # push!(first_pf_cont_vmag,[c,s,t,b]=>first_pf_c[c,s][t][1][b])
        push!(vmagc,[c,s,t,b]=>pf_per_dimension[c,s][t][1][b]) # pf_result_perscenario[33,10][24][1]
       end

   vangc=Dict{Array{Int64,1},Float64}()
   for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
      push!(vangc,[c,s,t,b]=>pf_per_dimension[c,s][t][2][b])
   end

    return vmagc,vangc
     end
end

function v_teta_dic_c_state_indep()
      # if indicator==1
       vmagc=Dict{Array{Int64,1},Float64}()
       for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
    # push!(first_pf_cont_vmag,[c,s,t,b]=>first_pf_c[c,s][t][1][b])
          push!(vmagc,[c,s,t,b]=>1)
         end

     vangc=Dict{Array{Int64,1},Float64}()
     for  c in 1:nCont, s in 1:nSc, t in 1:nTP, b in 1:nBus
        push!(vangc,[c,s,t,b]=>0)
     end
      return vmagc,vangc
  end

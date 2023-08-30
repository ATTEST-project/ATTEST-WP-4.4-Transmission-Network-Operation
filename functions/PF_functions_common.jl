function rect_to_polar(indicator)
    if indicator=="normal"
v_sq  =JuMP.value.(e[:,:]).^2+JuMP.value.(f[:,:]).^2
# v_sq_c=JuMP.value.(e_c[:,:,:,:]).^2+JuMP.value.(f_c[:,:,:,:]).^2
voltage_gen=JuMP.value.(v_sq[:,:]).^0.5
volt_ang=2*atan.(JuMP.value.(f[:,:])./(voltage_gen+JuMP.value.(e[:,:])))
v_sq_c=0
voltage_gen_c=0
volt_ang_c=0
return v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c
elseif indicator=="contin"
    v_sq  =JuMP.value.(e[:,:]).^2+JuMP.value.(f[:,:]).^2
    # v_sq_c=JuMP.value.(e_c[:,:,:,:]).^2+JuMP.value.(f_c[:,:,:,:]).^2
    voltage_gen=v_sq.^0.5
    volt_ang=2*atan.(JuMP.value.(f[:,:])./(voltage_gen+JuMP.value.(e[:,:])))
    v_sq_c  =JuMP.value.(e_c[:,:,:,:]).^2+JuMP.value.(f_c[:,:,:,:]).^2
    # v_sq_c=JuMP.value.(e_c[:,:,:,:]).^2+JuMP.value.(f_c[:,:,:,:]).^2
    voltage_gen_c=v_sq_c.^0.5
    volt_ang_c=2*atan.(JuMP.value.(f_c[:,:,:,:])./(voltage_gen_c+JuMP.value.(e_c[:,:,:,:])))

    return v_sq,voltage_gen,volt_ang,v_sq_c,voltage_gen_c,volt_ang_c
end

end

function trans_map(nBus,node_data_trans)
    from_to_map=Dict()
    for i in 1:nBus

     if  ~isempty(node_data_trans[i,1].node_num)
       for j in 1:size(node_data_trans[i,1].node_num,1)
           from_node=findall3(x->x==node_data_trans[i,1].node_num[j,1], idx_from_trans)
           to_node  =findall3(x->x==node_data_trans[i,1].node_cnode[j,1], idx_to_trans)

           check_idx= intersect(from_node,to_node)
           push!(from_to_map, [i,j]=> check_idx)
       end
   end
end

return from_to_map
end
# from_to_map=trans_map(nBus,node_data_trans)
function power_flow_initialization(array_bus,array_lines,array_gens,array_sbase,rdata_buses)
# nw_buses_pf = deepcopy(array_bus)       #we have it
nw_lines_pf = array_lines     #we have it
# nw_loads_pf = array_loads     #we have it
nw_gens_pf  = array_gens      #we have it
# nw_gcost_pf = array_gcost     #not needed
nw_sbase_pf = array_sbase     #we have it

# rdata_buses[:,2]=[array_bus[i].bus_type for i in 1:nBus]
# obus_type_pf    = rdata_buses[:,2]  #types of buses slack pv pq
# obus_type_pf= fixed_rdata_buses
# ordata_buses_pf = obus_type_pf      # acopy of the above types

v_initial_pf    = 1.00  #needed for initiallizatoin
max_mismatch_pf = 1     #
epsilon   = 1e-4        #convergence criteria
epsilon_suf=1e-3
iteration = 0           #iteration counter
itr_max   = 100       # max number of iterations
maxiter=[]
# nTP_pf = 24
# nSc_pf = 10

# nTP_pf = 1
# nSc_pf = 1
#types of buses
load_bus_type     = 1
vol_ctrl_bus_type = 2
slack_bus_type    = 3

v_sp_pf        = v_initial_pf.*exp(1.0im*0*pi/180)
node_vol_pf    = v_sp_pf
# node_vol_pf    = fill(v_sp_pf,(size(nw_buses_pf,1),nTP_pf,nSc_pf)) #bus*time*scenario 1+j0
node_vol_pf    = fill(v_sp_pf,(size(rdata_buses,1))) #bus*time*scenario 1+j0
# v_mag_pf       = abs.(node_vol_pf) #bus*time*scen 1
v_angle_pf     = angle.(node_vol_pf) #bus*time*scen 0


idx_nd_bsheet=Dict()
idx_nd_lsheet=Dict()
idx_nd_shunt=Dict()
idx_nd_gsheet=Dict()
idx_nd_RES=Dict()
idx_nd_Fl=Dict()
idx_nd_Str=Dict()

for i in 1:size(rdata_buses,1)
    # if !isnothing(indexin(i,nw_pPrf_data_load[:,1])[1])
    push!(idx_nd_lsheet, [i]=>indexin(i,nw_pPrf_data_load[:,1])[1])
    push!(idx_nd_shunt, [i]=>indexin(i,rdata_shunts[:,1])[1])
    push!(idx_nd_gsheet, [i]=>indexin(i,bus_data_gsheet)[1])
    push!(idx_nd_RES, [i]=>indexin(i,RES_bus)[1])
    push!(idx_nd_Fl, [i]=>indexin(i,nd_fl)[1])
    push!(idx_nd_Str, [i]=>indexin(i,nd_Str_active)[1])
end
      from_to_map=trans_map(nBus,node_data_trans)

      initialization=Dict(
      "nw_lines_pf"=>nw_lines_pf,
      # "nw_loads_pf"=>nw_loads_pf,
      "nw_gens_pf"=>nw_gens_pf,
      "nw_sbase_pf"=>nw_sbase_pf,
      "v_initial_pf"=>v_initial_pf,
      "epsilon"=>epsilon,
      "epsilon_suf"=>epsilon_suf,
      "iteration"=>iteration,
      "itr_max"=>itr_max,
      "maxiter"=>maxiter,
      "load_bus_type"=>load_bus_type,
      "vol_ctrl_bus_type"=>vol_ctrl_bus_type,
      "slack_bus_type"=>slack_bus_type,
      "v_sp_pf"=>v_sp_pf,
      "node_vol_pf"=>node_vol_pf,
      "v_angle_pf"=>v_angle_pf,
      # idx_nd_bsheet=idx_nd_bsheet,
      "idx_nd_lsheet"=>idx_nd_lsheet,
      "idx_nd_shunt"=>idx_nd_shunt,
      "idx_nd_gsheet"=>idx_nd_gsheet,
      "idx_nd_RES"=>idx_nd_RES,
      "idx_nd_Fl"=>idx_nd_Fl,
      "idx_nd_Str"=>idx_nd_Str,
      "from_to_map"=>from_to_map

      )
return initialization
end

function schedule_power(
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
        idx_nd_lsheet=initialization["idx_nd_lsheet"]
        idx_nd_shunt=initialization["idx_nd_shunt"]
        idx_nd_gsheet=initialization["idx_nd_gsheet"]
        idx_nd_RES=initialization["idx_nd_RES"]
        idx_nd_Fl=initialization["idx_nd_Fl"]
        idx_nd_Str=initialization["idx_nd_Str"]
    idx_sch = 0
    # p_sch=zeros(nBus-1)
    # q_sch=zeros(nBus-1)
    for i in 1:size(rdata_buses,1)
        # nd_num   = rdata_buses[i,1]
        bus_type = rdata_buses[i,2]

        if bus_type == 3
            idx_sch = idx_sch+1
        elseif bus_type !=3
     ##----------- Indices of Nodes in Buses, Loads and Generator Sheets ---------###

                idx_nd_bsheet = i              # Index of node in bus sheet

                idx_nd_bsheet = idx_nd_bsheet[1,1]-idx_sch
  #               println("")
  # show("$i,$idx_nd_bsheet")
  # println("")

            # end
            # p_sch_pf[idx_nd_bsheet,1]= (active_gen_profile)-active_load_profile-p_fl_increase+p_fl_decrease+p_discharge-p_charge
            # q_sch_pf[idx_nd_bsheet,1] = (reactive_gen_profile+react_shunt_pwr)-reactive_load_profile

                                     p_sch_pf[idx_nd_bsheet,1]=(
                                     # p_sch_pf[i,1]=(
                                       reduce(+,( active_gen[idx_nd_gsheet[[i]]] for k in 1 if !isnothing(idx_nd_gsheet[[i]]) ); init=0)
                                       +
                                       reduce(+,( prof_PRES_vec[idx_nd_RES[[i]]] for k in 1 if !isnothing(idx_nd_RES[[i]]) ); init=0)
                                       -
                                       reduce(+,( nd_ren_curt_vec[idx_nd_RES[[i]]] for k in 1 if !isnothing(idx_nd_RES[[i]]) ); init=0)
                                       +
                                       reduce(+,( p_dis_vec[idx_nd_Str[[i]]] for k in 1 if !isnothing(idx_nd_Str[[i]]) ); init=0)
                                        -
                                       reduce(+,( p_ch_vec[idx_nd_Str[[i]]] for k in 1 if !isnothing(idx_nd_Str[[i]]) ); init=0)
                                       -
                                       reduce(+,( nw_pPrf[idx_nd_lsheet[[i]]] for k in 1 if !isnothing(idx_nd_lsheet[[i]]) ); init=0)
                                       +
                                       reduce(+,( nd_load_curt_vec[idx_nd_lsheet[[i]]] for k in 1 if !isnothing(idx_nd_lsheet[[i]]) ); init=0)
                                       -
                                       reduce(+,( p_fl_inc_vec[idx_nd_Fl[[i]]] for k in 1 if !isnothing(idx_nd_Fl[[i]]) ); init=0)
                                       +
                                       reduce(+,( p_fl_dec_vec[idx_nd_Fl[[i]]] for k in 1 if !isnothing(idx_nd_Fl[[i]]) ); init=0)
                                        )


            # q_sch_pf[idx_nd_bsheet,1] = reactive_gen_profile+(react_shunt_pwr)-reactive_load_profile
              q_sch_pf[idx_nd_bsheet,1] = (
              # q_sch_pf[i,1] = (
                                       reduce(+,( reactive_gen[idx_nd_gsheet[[i]]] for k in 1 if ~isnothing(idx_nd_gsheet[[i]]) ); init=0)
                                           -
                                          reduce(+,( nw_qPrf[idx_nd_lsheet[[i]]] for k in 1 if ~isnothing(idx_nd_lsheet[[i]]) ); init=0)
                                          +
                                          reduce(+,( nd_shunt_vec[idx_nd_shunt[[i]]] for k in 1 if ~isnothing(idx_nd_shunt[[i]]) ); init=0)
                                          )


        end

    end


    return p_sch_pf,q_sch_pf
end
function lefthand_pb(
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
    y_bus_input,
    vol_nodes_mag_pf,
    vol_nodes_theta_pf
        )
        ybus=y_bus_input
        p_node_pf_calc_pf  = Dict()
        q_node_pf_calc_pf  = Dict()
        p_schedule_node_pf = Dict()
        q_schedule_node_pf = Dict()
        idx_nd_lsheet=initialization["idx_nd_lsheet"]
        idx_nd_shunt=initialization["idx_nd_shunt"]
        idx_nd_gsheet=initialization["idx_nd_gsheet"]
        idx_nd_RES=initialization["idx_nd_RES"]
        idx_nd_Fl=initialization["idx_nd_Fl"]
        idx_nd_Str=initialization["idx_nd_Str"]


        v_mag_aux   = vol_nodes_mag_pf
        v_angle_aux = vol_nodes_theta_pf

        for i in 1:size(rdata_buses,1)
            nd_num        = rdata_buses[i,1]
            # idx_nd_bsheet = indexin(nd_num,rdata_buses[:,1])
            idx_nd_bsheet = convert(Int64,nd_num)
            # idx_nd_lsheet = indexin(nd_num,rdata_loads[:,1])
            # idx_nd_gsheet = indexin(nd_num,rdata_gens[:,1])
            theta_diff    = vol_nodes_theta_pf[idx_nd_bsheet,1].-v_angle_aux
            p_inj = vol_nodes_mag_pf[idx_nd_bsheet,1]*sum(v_mag_aux.*((real(ybus[idx_nd_bsheet,:])).*cos.(theta_diff)+(imag(ybus[idx_nd_bsheet,:])).*sin.(theta_diff)),dims=1)
            q_inj = vol_nodes_mag_pf[idx_nd_bsheet,1]*sum(v_mag_aux.*((real(ybus[idx_nd_bsheet,:])).*sin.(theta_diff)-(imag(ybus[idx_nd_bsheet,:])).*cos.(theta_diff)),dims=1)
            push!(p_node_pf_calc_pf, [idx_nd_bsheet]=>p_inj[1,1])
            push!(q_node_pf_calc_pf, [idx_nd_bsheet]=>q_inj[1,1])
            # p_node_pf_calc_pf[idx_nd_bsheet,1] = p_inj[1,1]
            # q_node_pf_calc_pf[idx_nd_bsheet,1] = q_inj[1,1]

            push!(p_schedule_node_pf,
            [idx_nd_bsheet]=>(
              reduce(+,( active_gen[idx_nd_gsheet[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_gsheet[[idx_nd_bsheet]]) ); init=0)
              +
              reduce(+,( prof_PRES_vec[idx_nd_RES[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_RES[[idx_nd_bsheet]]) ); init=0)
              -
              reduce(+,( nd_ren_curt_vec[idx_nd_RES[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_RES[[idx_nd_bsheet]]) ); init=0)
              +
              reduce(+,( p_dis_vec[idx_nd_Str[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_Str[[idx_nd_bsheet]]) ); init=0)
               -
              reduce(+,( p_ch_vec[idx_nd_Str[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_Str[[idx_nd_bsheet]]) ); init=0)
              -
              reduce(+,( nw_pPrf[idx_nd_lsheet[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_lsheet[[idx_nd_bsheet]]) ); init=0)
              +
              reduce(+,( nd_load_curt_vec[idx_nd_lsheet[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_lsheet[[idx_nd_bsheet]]) ); init=0)
              -
              reduce(+,( p_fl_inc_vec[idx_nd_Fl[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_Fl[[idx_nd_bsheet]]) ); init=0)
              +
              reduce(+,( p_fl_dec_vec[idx_nd_Fl[[idx_nd_bsheet]]] for k in 1 if !isnothing(idx_nd_Fl[[idx_nd_bsheet]]) ); init=0)
                   )
                   )
            push!(q_schedule_node_pf,
                   [idx_nd_bsheet]=>(        reduce(+,( reactive_gen[idx_nd_gsheet[[idx_nd_bsheet]]] for k in 1 if ~isnothing(idx_nd_gsheet[[idx_nd_bsheet]]) ); init=0)
                                                -
                                               reduce(+,( nw_qPrf[idx_nd_lsheet[[idx_nd_bsheet]]] for k in 1 if ~isnothing(idx_nd_lsheet[[idx_nd_bsheet]]) ); init=0)
                                               +
                                               reduce(+,( nd_shunt_vec[idx_nd_shunt[[idx_nd_bsheet]]] for k in 1 if ~isnothing(idx_nd_shunt[[idx_nd_bsheet]]) ); init=0)
                                               )           )
                                           end
return p_node_pf_calc_pf,q_node_pf_calc_pf, p_schedule_node_pf,q_schedule_node_pf
end



function jacobian(rdata_buses,v_angle,v_mag,y_bus,J11,J12,J21,J22,idx_dPV_buses,p_injection,q_injection)
    idx_i = 0
    idx_j = 0

    for i in 1:size(rdata_buses,1)                                                 # Outer loop controls the indexing over rows of each sub-matrix in Jacobian matrix
        nd_num_i   = rdata_buses[i,1]
        bus_type_i = rdata_buses[i,2]

        if bus_type_i==3
            idx_i = idx_i+1
        elseif bus_type_i!=3
            # idx_nd_bsheet_i = findall3(x->x==nd_num_i,rdata_buses[:,1])
            idx_nd_bsheet_i = convert(Int64,nd_num_i)

            idx_nd_bsheet_i = idx_nd_bsheet_i[1,1]-idx_i
    for j in 1:size(rdata_buses,1)                                          # Inner loop controls the indexing over columns of each sub-matrix in Jacobian matrix
        nd_num_j   = rdata_buses[j,1]
        bus_type_j = rdata_buses[j,2]

        if bus_type_j==3
            idx_j = idx_j+1

        elseif bus_type_j!=3
                    if nd_num_i == nd_num_j                                      # Diagonal elements of Jacobian sub-matrices
                        # idx_nd_bsheet_j = findall3(x->x==nd_num_j,rdata_buses[:,1])
                        idx_nd_bsheet_j = convert(Int64,nd_num_j)

                        idx_nd_bsheet_j = idx_nd_bsheet_j[1,1]-idx_j
                        # theta_diff_jj   = v_angle[idx_nd_bsheet_j+idx_j,1].-v_angle
                        # p_inj = v_mag[idx_nd_bsheet_j+idx_j,1]*sum(v_mag.*((real(y_bus[idx_nd_bsheet_j+idx_j,:])).*cos.(theta_diff_jj)+(imag(y_bus[idx_nd_bsheet_j+idx_j,:])).*sin.(theta_diff_jj)),dims=1)
                        p_inj =values(p_injection[[idx_nd_bsheet_j+idx_j]])
                        # q_inj = v_mag[idx_nd_bsheet_j+idx_j,1]*sum(v_mag.*((real(y_bus[idx_nd_bsheet_j+idx_j,:])).*sin.(theta_diff_jj)-(imag(y_bus[idx_nd_bsheet_j+idx_j,:])).*cos.(theta_diff_jj)),dims=1)
                        q_inj =values(q_injection[[idx_nd_bsheet_j+idx_j]])
                        J11[idx_nd_bsheet_j,idx_nd_bsheet_j] = -q_inj[1,1]-v_mag[idx_nd_bsheet_j+idx_j,1]^2*imag(y_bus[idx_nd_bsheet_j+idx_j,idx_nd_bsheet_j+idx_j])
                        J21[idx_nd_bsheet_j,idx_nd_bsheet_j] =  p_inj[1,1]-v_mag[idx_nd_bsheet_j+idx_j,1]^2*real(y_bus[idx_nd_bsheet_j+idx_j,idx_nd_bsheet_j+idx_j])
                        J12[idx_nd_bsheet_j,idx_nd_bsheet_j] =  p_inj[1,1]+v_mag[idx_nd_bsheet_j+idx_j,1]^2*real(y_bus[idx_nd_bsheet_j+idx_j,idx_nd_bsheet_j+idx_j])
                        J22[idx_nd_bsheet_j,idx_nd_bsheet_j] =  q_inj[1,1]-v_mag[idx_nd_bsheet_j+idx_j,1]^2*imag(y_bus[idx_nd_bsheet_j+idx_j,idx_nd_bsheet_j+idx_j])
                    else                                                         # Off-diagonal elements of Jacobian sub-matrices
                        # idx_nd_bsheet_j = findall3(x->x==nd_num_j,rdata_buses[:,1])
                        idx_nd_bsheet_j = convert(Int64,nd_num_j)

                        idx_nd_bsheet_j = idx_nd_bsheet_j[1,1]-idx_j
                        theta_diff_ij   = v_angle[(idx_nd_bsheet_i+idx_i),1]-v_angle[(idx_nd_bsheet_j+idx_j),1]
                        real_val=real(y_bus[idx_nd_bsheet_i+idx_i,idx_nd_bsheet_j+idx_j])
                        imag_val=imag(y_bus[idx_nd_bsheet_i+idx_i,idx_nd_bsheet_j+idx_j])
                        sin_val=sin(theta_diff_ij)
                        cos_val=cos(theta_diff_ij)
                        partial_p_inj   = +1*(v_mag[idx_nd_bsheet_i+idx_i,1]*v_mag[idx_nd_bsheet_j+idx_j,1])*( real_val*sin_val-imag_val*cos_val)
                        partial_q_inj   = -1*(v_mag[idx_nd_bsheet_i+idx_i,1]*v_mag[idx_nd_bsheet_j+idx_j,1])*(real_val*cos_val+imag_val*sin_val)
                        J11[idx_nd_bsheet_i,idx_nd_bsheet_j] = partial_p_inj
                        J21[idx_nd_bsheet_i,idx_nd_bsheet_j] = partial_q_inj
                        J12[idx_nd_bsheet_i,idx_nd_bsheet_j] = -partial_q_inj
                        J22[idx_nd_bsheet_i,idx_nd_bsheet_j] = partial_p_inj
                    end
                end
            end                 # End inner for-loop
            idx_j = 0
        end
    end                         # End outer for-loop
    # idx_i = 0
    if isempty(idx_dPV_buses)   # No PV bus in a network
        J = [J11 J12;J21 J22]
    else                        # Deleting rows and columns which corresponds to PV buses in J12, J21 and J22 submatrices.
        J12_tmp = J12[:,setdiff(1:end,idx_dPV_buses)]
        J21_tmp = J21[setdiff(1:end,idx_dPV_buses),:]
        J22_tmp = J22[setdiff(1:end,idx_dPV_buses),setdiff(1:end,idx_dPV_buses)]
        J = [J11 J12_tmp;J21_tmp J22_tmp]
    end
    return J
end


function mismatch_vector(rdata_buses,v_angle,v_mag,y_bus,p_node,q_node,idx_dPV_buses,p_sch_pf,q_sch_pf)
    idx = 0
    p_injection=Dict()
    q_injection=Dict()
    for i in 1:size(rdata_buses,1)                                                  # Power Injection is calculated for both PV and PQ buses although there is no need for the calculation of Q injection for PV buses
        bus_type = rdata_buses[i,2]
        nd_num   = rdata_buses[i,1]

        if bus_type ==3
            idx = idx+1
        elseif bus_type!=3                                                       # Injection for PQ and PV buses
            # idx_nd_bsheet = findall3(x->x==nd_num,rdata_buses[:,1])
            idx_nd_bsheet = convert(Int64,nd_num)
            idx_nd_bsheet = idx_nd_bsheet[1,1]-idx
            theta_diff    = v_angle[idx_nd_bsheet+idx,1].-v_angle
            real_val=real(y_bus[idx_nd_bsheet+idx,:])
            imag_val=imag(y_bus[idx_nd_bsheet+idx,:])
            sin_val=sin.(theta_diff)
            cos_val=cos.(theta_diff)
            p_inj = v_mag[idx_nd_bsheet+idx,1]*sum(v_mag.*((real_val).*cos_val +(imag_val).*sin_val ),dims=1)
            push!(p_injection, [idx_nd_bsheet+idx]=>p_inj )

            q_inj = v_mag[idx_nd_bsheet+idx,1]*sum(v_mag.*((real_val).*sin_val-(imag_val).*cos_val),dims=1)
            push!(q_injection, [idx_nd_bsheet+idx]=>q_inj )
            p_node[idx_nd_bsheet,1] = p_inj[1,1]
            q_node[idx_nd_bsheet,1] = q_inj[1,1]
            # p_node = p_inj[1,1]
            # q_node = q_inj[1,1]
        end
    end
    delta_p = p_sch_pf.-p_node    # Mismatch active power
    delta_q = q_sch_pf.-q_node    # Mismatch reactive power

    if isempty(idx_dPV_buses)                                                    # No PV bus in the network
        delta_mismatch_inj = vcat(delta_p,delta_q)
    else                                                                         # Existence of PV buses in a system
        delta_q_tmp = deleteat!(delta_q,idx_dPV_buses)                           # Remove the corresponding reactive power mismatch entry from the delta_Y vector
        delta_mismatch_inj = vcat(delta_p,delta_q_tmp)
    end
# GC.gc()
 return delta_mismatch_inj,p_injection,q_injection
end

# mismatch_iman=mismatch_vector(nw_buses,rdata_buses,v_angle_pf,v_mag_pf,y_bus,p_node,q_node,[],p_sch_pf,q_sch_pf)

## -------------------- Handling PV and PQ buses data -----------------------###
##-----Indices of PV buses to be deleted from Jacobian and mismatch vector----##
function pv_pq_data(idx_PV_buses,idx_slack_bus,idx_PQ_buses)
            idx_dPV_buses = idx_PV_buses.-idx_slack_bus                          # Indices of deleted PV buses

            if all(idx_dPV_buses .>0)                                            # All PV buses are placed below the slack bus in the buses sheet
                idx_dPV_buses = idx_PV_buses.-1
            elseif all(idx_dPV_buses .<0)                                        # All PV buses are placed above the slack bus in the buses sheet
                idx_dPV_buses = idx_PV_buses
            else                                                                 # Few PV buses are below and few are above the slack bus in the buses sheet
                for i in 1:size(idx_dPV_buses,1)
                    if idx_dPV_buses[i]<0
                        idx_dPV_buses[i] = idx_PV_buses[i]
                    else
                        idx_dPV_buses[i] =  idx_PV_buses[i]-1
                    end
                end
            end
    ##---Indices of modified PQ buses obtained with respect to the slack bus ----##
            idx_dPQ_buses = idx_PQ_buses.-idx_slack_bus                          # Indices of modified PQ buses

            if all(idx_dPQ_buses .>0)                                            # All PQ buses are placed below the slack bus in the buses sheet
                idx_dPQ_buses = idx_PQ_buses.-1
            elseif all(idx_dPQ_buses .<0)                                        # All PQ buses are placed below the slack bus in the buses sheet
                idx_dPQ_buses = idx_PQ_buses
            else                                                                 # Few PQ buses are below and few are above the slack bus in the buses sheet
                for i in 1:size(idx_dPQ_buses,1)
                    if idx_dPQ_buses[i]<0
                        idx_dPQ_buses[i] = idx_PQ_buses[i]
                    else
                        idx_dPQ_buses[i] =  idx_PQ_buses[i]-1
                    end
                end
            end
 return idx_dPV_buses, idx_dPQ_buses
end
# idx_PV_buses_pf  = findall3(x->x==2,rdata_buses[:,2])
# idx_PQ_buses_pf  = findall3(x->x==1,rdata_buses[:,2])
#
# pv_pq_data(idx_PV_buses_pf,52,idx_PQ_buses_pf)


## ------ Code to retrieve the voltage magnitude and angle data ------------ ###
##----------- based upon the slack bus and the presence of PV buses -------- ###
function solution_voltage(slack_bus_type,rdata_buses,idx_PQ_buses,idx_PV_buses,idx_dPQ_buses,idx_dPV_buses,v_angle,v_mag,delta_x,idx_slack_bus)
    if isempty(idx_PV_buses)
        idx_slack_bus = indexin(slack_bus_type,rdata_buses[:,2])           # All buses are PQ buses and there is no PV bus

            if !isnothing(idx_slack_bus[1])
                idx_slack_bus = idx_slack_bus[1,1]
            end

        if isnothing(idx_slack_bus[1])
            v_angle[1:end,1] = v_angle[1:end,1]+delta_x[1:Int64(size(delta_x,1)/2),1]
            v_mag[1:end,1]   = v_mag[1:end,1].*(1.0 .+delta_x[Int64((size(delta_x,1)/2)+1):end,1])
            # v_mag[1:end,1]   = v_mag[1:end,1]+delta_x[Int64((size(delta_x,1)/2)+1):end,1]
        elseif idx_slack_bus == 1                                                # First bus in the Buses sheet is slack bus
            v_angle[idx_slack_bus+1:end,1] = v_angle[idx_slack_bus+1:end,1]+delta_x[1:Int64(size(delta_x,1)/2),1]
            v_mag[idx_slack_bus+1:end,1]   = v_mag[idx_slack_bus+1:end,1].*(1.0 .+delta_x[Int64((size(delta_x,1)/2)+1):end,1])
            # v_mag[idx_slack_bus+1:end,1]   = v_mag[idx_slack_bus+1:end,1]+delta_x[Int64((size(delta_x,1)/2)+1):end,1]
        elseif idx_slack_bus == size(rdata_buses,1)                                 # Last bus in the Buses sheet is slack bus
            v_angle[1:idx_slack_bus-1,1] = v_angle[1:idx_slack_bus-1,1]+delta_x[1:Int64(size(delta_x,1)/2),1]
            v_mag[1:idx_slack_bus-1,1]   = v_mag[1:idx_slack_bus-1,1].*(1.0 .+delta_x[Int64((size(delta_x,1)/2)+1):end,1])
            # v_mag[1:idx_slack_bus-1,1]   = v_mag[1:idx_slack_bus-1,1]+delta_x[Int64((size(delta_x,1)/2)+1):end,1]
        elseif idx_slack_bus>1 && idx_slack_bus < size(rdata_buses,1)               # Few buses are placed above and few are placed below the slack bus in the buses sheet
            before_length = length(1:idx_slack_bus-1)
            after_length  = length(idx_slack_bus+1:size(rdata_buses,1))
            v_angle[1:idx_slack_bus-1,1]       = v_angle[1:idx_slack_bus-1,1]+delta_x[1:before_length,1]
            v_angle[idx_slack_bus+1:end,1]     = v_angle[idx_slack_bus+1:end,1]+delta_x[before_length+1:Int64(size(delta_x,1)/2),1]
            # v_mag[1:idx_slack_bus-1,1]         = v_mag[1:idx_slack_bus-1,1].*(1.0 .+delta_x[Int64((size(delta_x,1)/2)+1):Int64(size(delta_x,1)/2)+before_length,1])
            # v_mag[idx_slack_bus+1:end,1]       = v_mag[idx_slack_bus+1:end,1].*(1.0 .+delta_x[Int64(size(delta_x,1)/2)+before_length+1:end,1])
            v_mag[1:idx_slack_bus-1,1]         = v_mag[1:idx_slack_bus-1,1]+delta_x[Int64((size(delta_x,1)/2)+1):Int64(size(delta_x,1)/2)+before_length,1]
            v_mag[idx_slack_bus+1:end,1]       = v_mag[idx_slack_bus+1:end,1]+delta_x[Int64(size(delta_x,1)/2)+before_length+1:end,1]
        end
    else                                                        # Network contains both PQ and PV buses. Voltage magnitude at PV buses is kept constant.
        delta_angle = delta_x[1:size(rdata_buses,1)-1]
        delta_mag   = delta_x[size(rdata_buses,1):end]
        v_angle[idx_PQ_buses] = v_angle[idx_PQ_buses]+delta_angle[idx_dPQ_buses]
        v_angle[idx_PV_buses] = v_angle[idx_PV_buses]+delta_angle[idx_dPV_buses]
        v_mag[idx_PQ_buses]   = v_mag[idx_PQ_buses].*(1.0.+delta_mag)
        # v_mag[idx_PQ_buses]   = v_mag[idx_PQ_buses]+delta_mag

    end
  return v_angle,v_mag
end

## -------------- Determining reactive generation at PV buses -------------####
# and switching PV bus to PQ bus in case Q-Gen hits the minimum or maximum limit#
# function pv_pq_switching(y_bus,nw_buses_pf,nw_loads_pf,nw_gens_pf,v_mag_pf,v_angle_pf,
#     rdata_buses,rdata_loads,rdata_gens,idx_oPV_buses_pf,load_bus_type,vol_ctrl_bus_type,mdf_idx_PV_buses_pf,nd_shunt_vec)
function pv_pq_switching(initialization,y_bus,nw_qPrf,v_mag_pf,v_angle_pf,
    rdata_buses,rdata_gens,idx_oPV_buses_pf,load_bus_type,vol_ctrl_bus_type,mdf_idx_PV_buses_pf,nd_shunt_vec,reactive_gen)
epsilon_suf=initialization["epsilon_suf"]
idx_nd_lsheet=initialization["idx_nd_lsheet"]
idx_nd_shunt=initialization["idx_nd_shunt"]
idx_nd_gsheet=initialization["idx_nd_gsheet"]
q_gen_pv_pf = zeros(size(idx_oPV_buses_pf,1))

for i in 1:size(idx_oPV_buses_pf,1)                                          # Reactive power injection at PV buses
    nd_num        = rdata_buses[idx_oPV_buses_pf[i]]
    # idx_nd_bsheet = indexin(nd_num,rdata_buses[:,1])
    idx_nd_bsheet = convert(Int64,nd_num)
    # idx_nd_lsheet = indexin(nd_num,rdata_loads[:,1])
    # idx_nd_gsheet = indexin(nd_num,rdata_gens[:,1])
    # idx_nd_shunt   = indexin(nd_num,rdata_shunts[:,1])
    # q_gen_max     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_max/nw_sbase_pf[1].sbase
    # q_gen_min     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_min/nw_sbase_pf[1].sbase
    # q_gen_max     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_max
    # q_gen_min     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_min
     q_gen_max     = qg_max[idx_nd_gsheet[[nd_num]]]
     q_gen_min     = qg_min[idx_nd_gsheet[[nd_num]]]
    theta_diff    = v_angle_pf[idx_oPV_buses_pf[i],1].-v_angle_pf
    q_inj         = v_mag_pf[idx_oPV_buses_pf[i],1]*sum(v_mag_pf.*((real(y_bus[idx_oPV_buses_pf[i],:])).*sin.(theta_diff)-(imag(y_bus[idx_oPV_buses_pf[i],:])).*cos.(theta_diff)),dims=1)
    # q_inj         = q_injection[[idx_oPV_buses_pf[i],1]]
    if !isnothing(idx_nd_lsheet[[nd_num]])                                           # Load connected to the PV bus
        # q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_loads_pf[idx_nd_lsheet[1,1]].load_Q-nw_loads_pf[idx_nd_lsheet[1,1]].load_B)
        q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_qPrf[idx_nd_lsheet[[nd_num]]])
    elseif  !isnothing(idx_nd_shunt[[nd_num]])                                                                  # No load connected to the PV bus and hence there is no mentioning of PV bus number in the load sheet
        q_gen_pv_pf[i,1] = q_inj[1,1]-nd_shunt_vec[idx_nd_shunt[[nd_num]]]
    elseif !isnothing(idx_nd_lsheet[[nd_num]]) && !isnothing(idx_nd_shunt[[nd_num]])
        q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_qPrf[idx_nd_lsheet[[nd_num]]])-nd_shunt_vec[idx_nd_shunt[[nd_num]]]
    else
        q_gen_pv_pf[i,1] = q_inj[1,1]
    end
        if q_gen_pv_pf[i,1] > q_gen_max +epsilon_suf                                     # Generated power becomes greator than the upper reactive power generation limit
            pwr = q_gen_pv_pf[i,1]
            # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = load_bus_type         # Switch to PQ bus
            rdata_buses[idx_nd_bsheet[1,1],2] = load_bus_type                # Switch to PQ bus
            # nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_avl = q_gen_max*nw_sbase_pf[1].sbase   # Setting Q_gen to the maximum limit
            reactive_gen[idx_nd_gsheet[[nd_num]]] = q_gen_max # Setting Q_gen to the maximum limit
            mdf_idx_PV_buses_pf[i] = load_bus_type
            # println("Generator G$nd_num: Q = $pwr >= Qmax = $q_gen_max => switched as PQ!")
        elseif q_gen_pv_pf[i,1] < q_gen_min -epsilon_suf                                 # Generated power becomes lower than the lower reactive power generation limit
            pwr = q_gen_pv_pf[i,1]
            # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = load_bus_type        # Switch to PQ bus
            rdata_buses[idx_nd_bsheet[1,1],2] = load_bus_type            # Switch to PQ bus
            # nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_avl = q_gen_min*nw_sbase_pf[1].sbase    # Setting Q_gen to the minimum limit
            reactive_gen[idx_nd_gsheet[[nd_num]]] = q_gen_min   # Setting Q_gen to the minimum limit
            mdf_idx_PV_buses_pf[i] = load_bus_type
            # println("Generator G$nd_num: Q = $pwr <= Qmin = $q_gen_min => switched as PQ!")
        elseif q_gen_min -epsilon_suf<= q_gen_pv_pf[i,1] <=q_gen_max +epsilon_suf  && mdf_idx_PV_buses_pf[i] == 1   # Qgen is within limits but the bus has switched from PV to PQ in the previous iteration
            pwr = q_gen_pv_pf[i,1]
            mdf_idx_PV_buses_pf[i] = 0
            # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = vol_ctrl_bus_type            # Switch the PQ bus back to PV bus in case there is no violation of reactive power generation limit
            rdata_buses[idx_nd_bsheet[1,1],2] = vol_ctrl_bus_type
            # println("Generator G$nd_num: Qmin = $q_gen_min <= Q = $pwr <= Qmax = $q_gen_max => switched back to PV!")
        end
end
return rdata_buses,reactive_gen
end
#     function pv_pq_switching(initialization,y_bus,nw_qPrf,v_mag_pf,v_angle_pf,
#         rdata_buses,rdata_loads,rdata_gens,idx_oPV_buses_pf,load_bus_type,vol_ctrl_bus_type,mdf_idx_PV_buses_pf,nd_shunt_vec,reactive_gen)
# epsilon_suf=initialization["epsilon_suf"]
# idx_nd_lsheet=initialization["idx_nd_lsheet"]
# idx_nd_shunt=initialization["idx_nd_shunt"]
# idx_nd_gsheet=initialization["idx_nd_gsheet"]
# # idx_nd_RES=initialization["idx_nd_RES"]
# # idx_nd_Fl=initialization["idx_nd_Fl"]
# # idx_nd_Str=initialization["idx_nd_Str"]
#
#     q_gen_pv_pf = zeros(size(idx_oPV_buses_pf,1))
#
#     for i in 1:size(idx_oPV_buses_pf,1)                                          # Reactive power injection at PV buses
#         nd_num        = rdata_buses[idx_oPV_buses_pf[i]]
#         # idx_nd_bsheet = indexin(nd_num,rdata_buses[:,1])
#         idx_nd_bsheet = convert(Int64,nd_num)
#         # idx_nd_lsheet = indexin(nd_num,rdata_loads[:,1])
#         # idx_nd_gsheet = indexin(nd_num,rdata_gens[:,1])
#         # idx_nd_shunt   = indexin(nd_num,rdata_shunts[:,1])
#         # q_gen_max     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_max/nw_sbase_pf[1].sbase
#         # q_gen_min     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_min/nw_sbase_pf[1].sbase
#         # q_gen_max     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_max
#         # q_gen_min     = nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_min
#
#         theta_diff    = v_angle_pf[idx_oPV_buses_pf[i],1].-v_angle_pf
#         q_inj         = v_mag_pf[idx_oPV_buses_pf[i],1]*sum(v_mag_pf.*((real(y_bus[idx_oPV_buses_pf[i],:])).*sin.(theta_diff)-(imag(y_bus[idx_oPV_buses_pf[i],:])).*cos.(theta_diff)),dims=1)
#         if !isnothing(idx_nd_lsheet[[nd_num]])                                           # Load connected to the PV bus
#             # q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_loads_pf[idx_nd_lsheet[1,1]].load_Q-nw_loads_pf[idx_nd_lsheet[1,1]].load_B)
#             q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_qPrf[idx_nd_lsheet[[nd_num]]])
#         elseif  !isnothing(idx_nd_shunt[[nd_num]])                                                                  # No load connected to the PV bus and hence there is no mentioning of PV bus number in the load sheet
#             q_gen_pv_pf[i,1] = q_inj[1,1]-nd_shunt_vec[idx_nd_shunt[[nd_num]]]
#         elseif !isnothing(idx_nd_lsheet[[nd_num]]) && !isnothing(idx_nd_shunt[[nd_num]])
#             q_gen_pv_pf[i,1] = q_inj[1,1] + (nw_qPrf[idx_nd_lsheet[[nd_num]]])-nd_shunt_vec[idx_nd_shunt[[nd_num]]]
#         else
#             q_gen_pv_pf[i,1] = q_inj[1,1]
#         end
#         if !isnothing(idx_nd_gsheet[[i]])
#             q_gen_max     = qg_max[idx_nd_gsheet[[i]]]
#             q_gen_min     = qg_min[idx_nd_gsheet[[i]]]
#             if q_gen_pv_pf[i,1] > q_gen_max +epsilon_suf                                     # Generated power becomes greator than the upper reactive power generation limit
#                 pwr = q_gen_pv_pf[i,1]
#                 # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = load_bus_type         # Switch to PQ bus
#                 rdata_buses[idx_nd_bsheet[1,1],2] = load_bus_type                # Switch to PQ bus
#                 # nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_avl = q_gen_max*nw_sbase_pf[1].sbase   # Setting Q_gen to the maximum limit
#                 reactive_gen[idx_nd_gsheet[[i]]] = q_gen_max # Setting Q_gen to the maximum limit
#                 mdf_idx_PV_buses_pf[i] = load_bus_type
#                 # println("Generator G$nd_num: Q = $pwr >= Qmax = $q_gen_max => switched as PQ!")
#             elseif q_gen_pv_pf[i,1] < q_gen_min -epsilon_suf                                 # Generated power becomes lower than the lower reactive power generation limit
#                 pwr = q_gen_pv_pf[i,1]
#                 # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = load_bus_type        # Switch to PQ bus
#                 rdata_buses[idx_nd_bsheet[1,1],2] = load_bus_type            # Switch to PQ bus
#                 # nw_gens_pf[idx_nd_gsheet[1,1]].gen_Qg_avl = q_gen_min*nw_sbase_pf[1].sbase    # Setting Q_gen to the minimum limit
#                 reactive_gen[idx_nd_gsheet[[i]]] = q_gen_min   # Setting Q_gen to the minimum limit
#                 mdf_idx_PV_buses_pf[i] = load_bus_type
#                 # println("Generator G$nd_num: Q = $pwr <= Qmin = $q_gen_min => switched as PQ!")
#             elseif q_gen_min -epsilon_suf<= q_gen_pv_pf[i,1] <=q_gen_max +epsilon_suf  && mdf_idx_PV_buses_pf[i] == 1   # Qgen is within limits but the bus has switched from PV to PQ in the previous iteration
#                 pwr = q_gen_pv_pf[i,1]
#                 mdf_idx_PV_buses_pf[i] = 0
#                 # nw_buses_pf[idx_nd_bsheet[1,1]].bus_type = vol_ctrl_bus_type            # Switch the PQ bus back to PV bus in case there is no violation of reactive power generation limit
#                 rdata_buses[idx_nd_bsheet[1,1],2] = vol_ctrl_bus_type
#                 # println("Generator G$nd_num: Qmin = $q_gen_min <= Q = $pwr <= Qmax = $q_gen_max => switched back to PV!")
#             end
#     end
# end
#   return rdata_buses,reactive_gen
# end



 function total_result(indicator,power_flow_normal_result,power_flow_contin_result)


if indicator=="normal"
    pf_result_perscen_normal    =power_flow_normal_result["pf_result_perscen_normal"]
    branch_flow_check           =power_flow_normal_result["branch_flow_check"]
    voltage_viol_number         =power_flow_normal_result["voltage_viol_number"]
    volt_viol_normal            =power_flow_normal_result["volt_viol_normal"]

       total_normal_voltage_violation=size(voltage_viol_number,1)
       println("Total number of voltage violation in normal operation $total_normal_voltage_violation")

       br_viol_nr =[]
       for  t in 1:nTP
           if ~isempty(branch_flow_check[t][2])
               for j in branch_flow_check[t][2][1]
               push!(br_viol_nr,[t,idx_from_line[j],idx_to_line[j]])
               push!(br_viol_nr,[t,idx_to_line[j],idx_from_line[j]])
           end  end
       end

       total_normal_br_violation=size(br_viol_nr,1)/2
       println("Total number of branch violation in normal operation  $total_normal_br_violation")

 return total_normal_voltage_violation,total_normal_br_violation,0,0

   elseif indicator=="contin"
                        pf_per_dimension           =power_flow_contin_result["pf_per_dimension"]
                        branch_flow_check_c        =power_flow_contin_result["branch_flow_check_c"]
                        voltage_viol_contin_number =power_flow_contin_result["voltage_viol_contin_number"]
                        volt_viol_contin           =power_flow_contin_result["volt_viol_contin"]

       total_contin_voltage_violation=size(voltage_viol_contin_number,1)

       println("Total number of voltage violation in contingencies    $total_contin_voltage_violation")



       br_viol_c=[]
       for c in 1:nCont, s in 1:nSc, t in 1:nTP
           if ~isempty(branch_flow_check_c[c,s,t][2])
               for j in branch_flow_check_c[c,s,t][2][1]
               push!(br_viol_c,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]])
               push!(br_viol_c,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]])
           end  end
       end
       total_contin_br_violation=size(br_viol_c,1)/2
       println("Total number of branch violation in contingencies    $total_contin_br_violation")
       return 0,0,total_contin_voltage_violation,total_contin_br_violation


elseif indicator=="all"
    pf_result_perscen_normal    =power_flow_normal_result["pf_result_perscen_normal"]
    branch_flow_check           =power_flow_normal_result["branch_flow_check"]
    voltage_viol_number         =power_flow_normal_result["voltage_viol_number"]
    volt_viol_normal            =power_flow_normal_result["volt_viol_normal"]
        idx_conv_norm            =power_flow_normal_result["convergence"]
    pf_per_dimension           =power_flow_contin_result["pf_per_dimension"]
    branch_flow_check_c        =power_flow_contin_result["branch_flow_check_c"]
    voltage_viol_contin_number =power_flow_contin_result["voltage_viol_contin_number"]
    volt_viol_contin           =power_flow_contin_result["volt_viol_contin"]
      idx_conv_contin     =power_flow_contin_result["convergence"]


       total_normal_voltage_violation=size(voltage_viol_number,1)
       if isempty(idx_conv_norm)
       println("")
       show("Total number of voltage violation in normal operation $total_normal_voltage_violation")
       println("")
   end

       br_viol_nr =[]
       for  t in 1:nTP
           if ~isempty(branch_flow_check[t][2])
               for j in branch_flow_check[t][2][1]
               push!(br_viol_nr,[t,idx_from_line[j],idx_to_line[j]])
               push!(br_viol_nr,[t,idx_to_line[j],idx_from_line[j]])
           end  end
       end

       total_normal_br_violation=size(br_viol_nr,1)/2
       if isempty(idx_conv_norm)
       println("Total number of branch violation in normal operation  $total_normal_br_violation")
   end

       total_contin_voltage_violation=size(voltage_viol_contin_number,1)
       if isempty(idx_conv_contin)
       println("Total number of voltage violation in contingencies    $total_contin_voltage_violation")
   end



       br_viol_c=[]
       for c in 1:nCont, s in 1:nSc, t in 1:nTP
           if ~isempty(branch_flow_check_c[c,s,t][2])
               for j in branch_flow_check_c[c,s,t][2][1]
               push!(br_viol_c,[c,s,t,idx_from_line_c[c][j],idx_to_line_c[c][j]])
               push!(br_viol_c,[c,s,t,idx_to_line_c[c][j],idx_from_line_c[c][j]])
           end  end
       end
       total_contin_br_violation=size(br_viol_c,1)/2
       if isempty(idx_conv_contin)
       println("Total number of branch violation in contingencies    $total_contin_br_violation")
   end

       # save("pf_full_problem.jld"
       # , "pf_normal",pf_result_perscen_normal
       # # , "pf_post_contin",pf_per_dimension
       # , "branch_flow_check_normal",branch_flow_check
       # # , "branch_flow_check_contin",branch_flow_check_c
       # )
       return total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation

end
       end


# initialization=power_flow_initialization(array_bus,array_lines,array_loads,array_gens,array_sbase,rdata_buses)
       function power_flow(norm_or_contin_or_both,init_or_non_init_normal, out_of_pf_opf_normal,v_indic_normal,v_indic_contin,contin_SA)
           initialization=power_flow_initialization(array_bus,array_lines,array_gens,array_sbase,rdata_buses)

             if norm_or_contin_or_both=="normal"

            input_normal=PF_input_normal(initialization,out_of_pf_opf_normal,v_indic_normal)
           # input_contin=PF_input_contin(initialization,"contin","v_pol")
            power_flow_normal_result=run_PF_normal(initialization,input_normal,init_or_non_init_normal)
          # power_flow_contin_result=run_PF_contin(initialization,input_contin,"contin")
             total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation=total_result("normal",power_flow_normal_result,0)
             return (input_normal,0,power_flow_normal_result,0,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation)
       elseif norm_or_contin_or_both=="contin"

           # input_normal=PF_input_normal(initialization,out_of_pf_opf_normal,v_indic_normal)
             input_contin=PF_input_contin(initialization,contin_SA,v_indic_contin)
           # power_flow_normal_result=run_PF_normal(initialization,input_normal,init_or_non_init_normal)
            power_flow_contin_result=run_PF_contin(initialization,input_contin,contin_SA)
            total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation=total_result("contin",0,power_flow_contin_result)
            return (0,input_contin,0,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation)

       elseif norm_or_contin_or_both=="all"
           input_normal=PF_input_normal(initialization,out_of_pf_opf_normal,v_indic_normal)
             input_contin=PF_input_contin(initialization,contin_SA,v_indic_contin)
           power_flow_normal_result=run_PF_normal(initialization,input_normal,init_or_non_init_normal)
            power_flow_contin_result=run_PF_contin(initialization,input_contin,contin_SA)
            total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation=total_result("all",power_flow_normal_result,power_flow_contin_result)
            return (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation)

       end

       end


 (v0_n,teta0_n)=v_teta_dic_n_state_indep()
 (v0_c,teta0_c)=v_teta_dic_c_state_indep()

  (v0_n,teta0_n)=pf_v_teta_dic_n()
  (v0_c,teta0_c)=pf_v_teta_dic_c(1)

 @time (model_name, bounded_segment_n,bounded_segment_c,infeas_flag)=DC_SCOPF("scopf",2,1,0,0)

 @time  (input_normal,input_contin,power_flow_normal_result,power_flow_contin_result,total_normal_voltage_violation,total_normal_br_violation,total_contin_voltage_violation,total_contin_br_violation
          )=power_flow("all","non_initial", "out_of_OPF","v_sqr","v_sqr","contin")

ploss_dic_iman=Dict{Array{Int64,1}, Float64}()
qloss_dic_iman=Dict{Array{Int64,1}, Float64}()
# ploss_dic_iman=[]
          for t in 1:nTP

              for i in 1:nBus
                  # for i in [47]
                  idx_nd_nw_buses = indexin(i,rdata_buses[:,1])
                  idx_nd_nw_buses = idx_nd_nw_buses[1,1]

              if  ~isempty(node_data[i,1].node_num)


                  for j in 1:size(node_data[i,1].node_num,1)                                                # length of each node vector in 'node_data' variable

                      gij_line    = node_data[i,1].node_gij_sr[j,1]
                      bij_line    = node_data[i,1].node_bij_sr[j,1]
                      cnctd_nd    = node_data[i,1].node_cnode[j,1]
                      idx_cnctd_nd = indexin(cnctd_nd,rdata_buses[:,1])
                      idx_cnctd_nd = idx_cnctd_nd[1,1]
                      gij_line_sh = node_data[i,1].node_gij_sh[j,1]
                      bij_line_sh = node_data[i,1].node_bij_sh[j,1]
                      s_max      =  node_data[i,1].node_smax[j,1]
                      lf_tetap= gij_line*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )*(value.(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]))-0.5*gij_line*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2)
                      lf_voltp=gij_line*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd]]))*(value.(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd]))-0.5*gij_line*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2)


          lf_tetaq= (-bij_line)*(teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )*(value.(teta[t,idx_nd_nw_buses]-teta[t,idx_cnctd_nd]))-0.5*(-bij_line)*((teta0_n[[t,idx_nd_nw_buses]]-teta0_n[[t,idx_cnctd_nd]] )^2)
          lf_voltq= (-bij_line)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])/(v0_n[[t,idx_nd_nw_buses]]+v0_n[[t,idx_cnctd_nd]]))*(value.(v_sq[t,idx_nd_nw_buses]-v_sq[t,idx_cnctd_nd]))-0.5*(-bij_line)*((v0_n[[t,idx_nd_nw_buses]]-v0_n[[t,idx_cnctd_nd]])^2)

         push!(ploss_dic_iman,  [t,idx_nd_nw_buses,idx_cnctd_nd] => lf_tetaq)
         push!(qloss_dic_iman,  [t,idx_nd_nw_buses,idx_cnctd_nd] => lf_voltq)
          # push!(ploss_dic_iman,  lf_tetap+lf_voltp)
end
end

end

end



ploss_c_dict=Dict{Array{Int64,1}, Float64}()

for c in 1:nCont
   for s in 1:nSc
       for t in 1:nTP
           for i in 1:nBus

           # nd      = node_data_contin[c][i].node_num_c                                    # Node num is independant of time period and scenario
           # nd_num  = unique(nd)
           # nd_num  = nd_num[1,1]

           # idx_nd_nw_buses = indexin(i,rdata_buses[:,1])
           # idx_nd_nw_buses = idx_nd_nw_buses[1,1]
           idx_nd_nw_buses= i
           # idx_fr_trans =indexin(i,idx_from_trans)
           if  ~isempty(node_data_contin[c][i].node_num_c)


                   for j in 1:size(node_data_contin[c][i].node_num_c,1)                                                # length of each node vector in 'node_data' variable

                       gij_line    = node_data_contin[c][i].node_gij_sr_c[j]
                       bij_line    = node_data_contin[c][i].node_bij_sr_c[j]
                       cnctd_nd    = node_data_contin[c][i].node_cnode_c[j]
                       # idx_cnctd_nd = indexin(cnctd_nd,rdata_buses[:,1])
                       idx_cnctd_nd = cnctd_nd[1,1]
                       gij_line_sh = node_data_contin[c][i].node_gij_sh_c[j]
                       bij_line_sh = node_data_contin[c][i].node_bij_sh_c[j]
                       s_max      =  node_data_contin[c][i].node_smax_c[j]
                       lf_tetap=@expression(model_name, gij_line*(teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )*value.(teta_c[c,s,t,idx_nd_nw_buses]-teta_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*((teta0_c[[c,s,t,idx_nd_nw_buses]]-teta0_c[[c,s,t,idx_cnctd_nd]] )^2) )

                       lf_voltp=@expression(model_name, gij_line*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])/(v0_c[[c,s,t,idx_nd_nw_buses]]+v0_c[[c,s,t,idx_cnctd_nd]]))*value.(v_sq_c[c,s,t,idx_nd_nw_buses]-v_sq_c[c,s,t,idx_cnctd_nd])-0.5*gij_line*((v0_c[[c,s,t,idx_nd_nw_buses]]-v0_c[[c,s,t,idx_cnctd_nd]])^2)  )
              push!(ploss_c_dict,  [c,s,t,idx_nd_nw_buses,idx_cnctd_nd] => lf_tetap+lf_voltp)
          end
      end
  end
end
end
end

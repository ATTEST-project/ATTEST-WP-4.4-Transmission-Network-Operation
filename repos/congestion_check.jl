line_flow_normal_s_exp=@expression(acopf, [s in 1:nSc, t in 1:nTP, l in 1:nLines],
((value.(pinj_dict_sr[[s,t,idx_from_line[l],idx_to_line[l]]]))^2+(value.(qinj_dict_sr[[s,t,idx_from_line[l],idx_to_line[l]]]))^2
)/(nw_lines[l].line_Smax_A)^2)

# line_flow_normal_r_exp=@expression(acopf, [s in 1:nSc, t in 1:nTP, l in 1:nLines],
# ((value.(pinj_dict_sr[[s,t,idx_to_line[l],idx_from_line[l]]]))^2+(value.(qinj_dict_sr[[s,t,idx_to_line[l],idx_from_line[l]]]))^2
# )/(nw_lines[l].line_Smax_A)^2)

congested_normal_s=findall(x->x>0.8, line_flow_normal_s_exp)
congested_normal_value=[line_flow_normal_s_exp[i] for i in congested_normal_s]
congested_normal_value=sqrt.(congested_normal_value)
line_flow_contin_s_exp=Dict()
for c in 1:nCont, s in 1:nSc, t in 1:nTP, l in 1:length(idx_from_line_c[c])
    val_exp=( (value.(pinj_dict_c_sr[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]))^2+(value.(qinj_dict_c_sr[[c,s,t,idx_from_line_c[c][l],idx_to_line_c[c][l]]]))^2)/(line_smax_c[c][l])^2
    push!(line_flow_contin_s_exp, [c,s,t,l]=>val_exp)

end


congested_contin_s=findall(x->x>0.8, line_flow_contin_s_exp)
congested_contin_value=[line_flow_contin_s_exp[[congested_contin_s[i][1],congested_contin_s[i][2],congested_contin_s[i][3],congested_contin_s[i][4]]] for i in 1:length(congested_contin_s)]
congested_contin_value=sqrt.(congested_contin_value)


prof_ploads = Load_MAG*nw_pPrf_data_load[:,2:end]*load_correction
# prof_qloads =Load_MAG*nw_qPrf_data_load[:,2:end]*load_correction
bus_data_lsheet       = nw_pPrf_data_load[:,1]
nLoads = length(prof_ploads[:,1])
if !isempty(RES_bus)
load_bus_map=convert.(Int64, nw_pPrf_data_load[:,1])
# prof_ploads = Load_MAG*nw_pPrf_data_load[:,2:end]*load_correction
# nw_pPrf_data_load= hcat(load_bus_map,prof_ploads)
# prof_EV     = rdata_EVProfile_load[:,2:end]
load_dict=Dict{Int64,Float64}()
for i in 1:size(nw_pPrf_data_load[:,1],1)
    push!(load_dict, nw_pPrf_data_load[i,1]=>nw_pPrf_data_load[i,2:end][1] )
end
PV_dict=Dict{Int64,Float64}()
for i in 1:size(RES_bus[:,1],1)
    push!(PV_dict, RES_bus[i]=>-prof_PRES[1,1,i] )
end
for i in union(keys(load_dict),keys(PV_dict))
    if haskey(load_dict, i) && haskey(PV_dict, i)
        push!(load_dict, i=> values(load_dict[i])+values(PV_dict[i]) )
    elseif haskey(load_dict, i) && !haskey(PV_dict, i)
        push!(load_dict, i=> values(load_dict[i]) )
    elseif !haskey(load_dict, i) && haskey(PV_dict, i)
        push!(load_dict, i=> values(PV_dict[i]) )
    end
end

n_load=sort(collect(load_dict))
new_load=zeros(length(keys(load_dict)) , nTP+1)
for i in 1:length(keys(load_dict))
    new_load[i,1]=n_load[i][1]
    new_load[i,2:end].=n_load[i][2]
end
nw_pPrf_data_load=new_load
prof_ploads=nw_pPrf_data_load[:,2:end]
nLoads = length(prof_ploads[:,1])
end
#.====================REactive=========================

prof_qloads =Load_MAG*nw_qPrf_data_load[:,2:end]*load_correction
# nw_qPrf_data_load= hcat(load_bus_map,prof_qloads)
# prof_EV_q     = tan(acos(power_factor))*rdata_EVProfile_load[:,2:end]
# rdata_EVProfile_loadq= hcat(rdata_EVProfile_load[:,1],prof_EV_q)

if !isempty(RES_bus)
#
qload_dict=Dict{Int64,Float64}()
for i in 1:size(nw_qPrf_data_load[:,1],1)
    push!(qload_dict, nw_qPrf_data_load[i,1]=>nw_qPrf_data_load[i,2:end][1] )
end
qPV_dict=Dict{Int64,Float64}()
for i in 1:size(RES_bus[:,1],1)
    push!(qPV_dict, RES_bus[i]=>0.0 )
end
for i in union(keys(qload_dict),keys(qPV_dict))
    if haskey(qload_dict, i) && haskey(qPV_dict, i)
        push!(qload_dict, i=> values(qload_dict[i])+values(qPV_dict[i]) )
    elseif haskey(qload_dict, i) && !haskey(qPV_dict, i)
        push!(qload_dict, i=> values(qload_dict[i]) )
    elseif !haskey(qload_dict, i) && haskey(qPV_dict, i)
        push!(qload_dict, i=> values(qPV_dict[i]) )
    end
end

qn_load=sort(collect(qload_dict))
new_qload=zeros(length(keys(qload_dict)) , nTP+1)
for i in 1:length(keys(qload_dict))
    new_qload[i,1]=qn_load[i][1]
    new_qload[i,2:end].=qn_load[i][2]
end
nw_qPrf_data_load=new_qload
prof_qloads=nw_qPrf_data_load[:,2:end]
end

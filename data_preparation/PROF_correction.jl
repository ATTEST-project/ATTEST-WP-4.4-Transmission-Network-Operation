res_data = ods_readall(filename_prof;sheetsNames=["RES"],innerType="Matrix")
res_data = res_data["RES"]
res_data = res_data[2:end,:]
res_map=res_data[:,1]
old_res=deepcopy(res_map)
for i in 1:length(res_map[:,1])
    idx_res=findall(x->x==res_map[i,1], map[:,2])
    if !isempty(idx_res)
    replace!(old_res ,old_res[i,1]=> map[idx_res[1],1])
    end
    # old_res=replace!(old_res ,old_res[i,1]=> map[findall(x->x==res_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam)_PROF.ods",Dict(("RES",2,1)=>[old_res res_data[:,2]]))
res_data=nothing



loadd_data = ods_readall(filename_prof;sheetsNames=["Loads"],innerType="Matrix")
loadd_data = loadd_data["Loads"]
loadd_data = loadd_data[2:end,:]
load_map=loadd_data[:,1]
old_load=deepcopy(load_map)
for i in 1:length(load_map[:,1])
    # idx_l=findall(x->x==load_map[i,1], map[:,2])
    # if !isempty(idx_l)
    # replace!(old_load ,old_load[i,1]=> map[idx_l[1],1])
    # end
    old_load[i,:]=replace!(old_load[i,:] ,old_load[i,1]=> map[findall(x->x==load_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam)_PROF.ods",Dict(("Loads",2,1)=>[old_load loadd_data[:,2]]))
loadd_data=nothing

ploadd_data = ods_readall(filename_prof;sheetsNames=["P_Profiles_Load"],innerType="Matrix")
ploadd_data = ploadd_data["P_Profiles_Load"]
ploadd_data = ploadd_data[2:end,:]
ods_write("input_data\\$(nam)_PROF.ods",Dict(("P_Profiles_Load",2,1)=>[old_load ploadd_data[:,2]]))
ploadd_data=nothing

qloadd_data = ods_readall(filename_prof;sheetsNames=["Q_Profiles_Load"],innerType="Matrix")
qloadd_data = qloadd_data["Q_Profiles_Load"]
qloadd_data = qloadd_data[2:end,:]
ods_write("input_data\\$(nam)_PROF.ods",Dict(("Q_Profiles_Load",2,1)=>[old_load qloadd_data[:,2]]))
qloadd_data=nothing

contingency_data = ods_readall(filename_prof;sheetsNames=["contingencies"],innerType="Matrix")
contingency_data = contingency_data["contingencies"]
contingency_data = contingency_data[2:end,:]
c_map=contingency_data[:,2:3]
old_c=deepcopy(c_map)
for i in 1:length(c_map[:,1])
    old_c[i,:]=replace!(old_c[i,:] ,old_c[i,1]=> map[findall(x->x==c_map[i,1], map[:,2])[1],1])
    old_c[i,:]=replace!(old_c[i,:] ,old_c[i,2]=> map[findall(x->x==c_map[i,2], map[:,2])[1],1])
end
ods_write("input_data\\$(nam)_PROF.ods",Dict(("contingencies",2,2)=>old_c))
# contingency_data=nothing


str_data = ods_readall(filename_prof;sheetsNames=["Storage"],innerType="Matrix")
str_data = str_data["Storage"]
str_data = str_data[2:end,:]
st_map=str_data[:,1]
old_st=deepcopy(st_map)
for i in 1:length(st_map[:,1])
    # idx_st=findall(x->x==st_map[i,1], map[:,2])
    # if !isempty(idx_st)
    # replace!(old_st ,old_st[i,1]=> map[idx_st[1],1])
    # end
    old_st[i,:]=replace!(old_st[i,:] ,old_st[i,1]=> map[findall(x->x==st_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam)_PROF.ods",Dict(("Storage",2,1)=>[old_st str_data[:,2]]))
str_data=nothing
